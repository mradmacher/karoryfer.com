class AlbumView < ResourceView
  def _path
    artist_album_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_album_path(resource.artist, resource)
  end
end
