class TrackPresenter < ResourcePresenter
  def_delegators(:resource, :title)

  def _path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end

  def _edit_path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end
end
