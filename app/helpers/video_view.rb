class VideoView < ResourceView
  def _path
    artist_video_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_video_path(resource.artist, resource)
  end
end
