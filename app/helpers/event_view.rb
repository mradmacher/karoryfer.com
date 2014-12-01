class EventView < ResourceView
  def _path
    artist_event_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_event_path(resource.artist, resource)
  end
end
