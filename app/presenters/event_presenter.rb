class EventPresenter < Presenter
  def_delegators(:resource, :title, :body, :poster?, :poster,
    :location, :address,
    :expired?, :event_date, :event_time, :duration,
    :price, :free_entrance?,
    :recognized_external_urls, :artist)

  def _path
    artist_event_path(resource.artist, resource)
  end

  def _edit_path
    edit_artist_event_path(resource.artist, resource)
  end
end
