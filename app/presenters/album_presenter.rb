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
    edit_artist_album_path(album.artist, album)
  end

  def downloads
    resource.releases.sum(:downloads)
  end

  def free_releases
    resource.releases.where(for_sale: false).map { |r| ReleasePresenter.new(r) }
  end

  def paid_releases
    resource.releases.where(for_sale: true).map { |r| ReleasePresenter.new(r) }
  end

  def releases
    resource.releases.map { |r| ReleasePresenter.new(r) }
  end

  def tracks
    @tracks = TrackPresenter.presenters_for(resource.tracks)
  end
end
