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

  def download
    artist = Artist.find_by_reference(params[:artist_id])
    album = artist.albums.find_by_reference(params[:id])
    downloader = Downloader.new(album, remote_ip: request.remote_ip)
    downloadable =
      if params[:pid]
        downloader.purchased_download(params[:pid])
      else
        downloader.free_download(params[:f])
      end

    if downloadable.nil?
      redirect_to artist_album_url(artist, album)
    elsif downloadable.is_a?(String)
      redirect_to downloadable
    else
      response.headers['Content-Length'] = downloadable.file.size.to_s
      send_file downloadable.file.path, disposition: 'attachment', type: 'application/zip'
    end
  rescue Downloader::DownloadsExceededError
    flash[:downloads_exceeded] = true
    redirect_to artist_album_url(artist, album)
  rescue Downloader::NotPurchasedError
    redirect_to artist_album_url(artist, album)
  end

  private

  def find
    current_artist.albums.find_by_reference(params[:id])
  end
end
