class EventView < ResourceView
  def_delegators(:resource, :title, :body, :poster?, :poster,
    :expired?, :location, :address, :event_time, :price, :free_entrance?,
    :recognized_external_urls, :artist)

  def _path
    artist_event_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_event_path(resource.artist, resource)
  end
end
