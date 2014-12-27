class AlbumPresenter < ResourcePresenter
  def_delegators(:resource, :title, :published?, :image?,
    :image, :license, :year, :donation, :description,
    :artist, :releases, :tracks, :attachments)

  def _path
    artist_album_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_album_path(resource.artist, resource)
  end
end
