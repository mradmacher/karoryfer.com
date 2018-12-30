# frozen_string_literal: true

class AlbumPresenter < Presenter
  def_delegators(:resource,
                 :title,
                 :published?,
                 :image?,
                 :image,
                 :license,
                 :year,
                 :donation,
                 :description,
                 :artist,
                 :attachments)

  alias album resource

  def path
    artist_album_path(album.artist, album)
  end

  def edit_path
    edit_admin_artist_album_path(album.artist, album)
  end

  def delete_path
    admin_artist_album_path(album.artist, album)
  end

  def free_releases
    releases.reject(&:for_sale?)
  end

  def paid_releases
    releases.select(&:for_sale?).map do |release_presenter|
      release_presenter.tap do |rp|
        rp.purchase_reference_id = purchase.reference_id if rp.id == purchase&.release_id
        rp.discount = discount if rp.id == discount&.release_id
      end
    end
  end

  def releases
    @releases = resource.releases.map { |r| ReleasePresenter.new(r) }
  end

  def tracks
    @tracks = TrackPresenter.presenters_for(resource.tracks)
  end

  attr_accessor :purchase, :discount

end
