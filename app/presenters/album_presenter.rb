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
                 :releases,
                 :tracks,
                 :attachments)

  def path
    artist_album_path(resource.artist, resource)
  end

  def edit_path
    edit_artist_album_path(resource.artist, resource)
  end

  def can_be_updated?
    abilities.allow?(:write, resource)
  end

  def can_be_deleted?
    can_be_updated?
  end
end
