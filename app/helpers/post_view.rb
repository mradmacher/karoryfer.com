class PostView < ResourceView
  def _path
    artist_post_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_post_path(resource.artist, resource)
  end
end
