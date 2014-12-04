class ArtistView < ResourceView
  def _path
    artist_path(resource)
  end

  def _edit_path
    edit_artist_path(resource)
  end
end
