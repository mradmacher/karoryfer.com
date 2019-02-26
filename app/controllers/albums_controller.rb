# frozen_string_literal: true

class AlbumsController < CurrentArtistController
  layout :set_layout

  def index
    @presenters = AlbumPresenter.presenters_for(current_artist.albums.published)
  end

  def show
    @presenter = AlbumPresenter.new(find)
    @presenter.purchase = Purchase.where(reference_id: params[:pid]).first if params[:pid]
    @presenter.discount = Discount.where(reference_id: params[:did]).first if params[:did]
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def download
    artist = Artist.find_by_reference(params[:artist_id])
    album = artist.albums.find_by_reference(params[:id])
    release = album.releases.in_format(params[:download]).first!
    purchase = Purchase.where(reference_id: params[:pid]).first if params[:pid]
    if !release.for_sale? || release.purchased?(purchase)
      if purchase&.downloads_exceeded?
        flash[:downloads_exceeded] = true
        redirect_to artist_album_url(artist, album)
      elsif release.file?
        purchase&.increment!(:downloads) || release.increment!(:downloads)
        response.headers['Content-Length'] = release.file.size.to_s
        send_file release.file.path, disposition: 'attachment', type: 'application/zip'
      elsif release.url
        redirect_to release.url
      else
        redirect_to artist_album_url(artist, album)
      end
    else
      redirect_to artist_album_url(artist, album)
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  private

  def find
    current_artist.albums.find_by_reference(params[:id])
  end
end
