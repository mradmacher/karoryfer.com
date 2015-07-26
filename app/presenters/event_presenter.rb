class EventPresenter < Presenter
  def_delegators(:resource, :title, :body, :poster?, :poster,
    :location, :address,
    :expired?, :event_date, :event_time, :duration,
    :price, :free_entrance?,
    :recognized_external_urls, :artist)

  def path
    artist_event_path(resource.artist, resource)
  end

  def edit_path
    edit_artist_event_path(resource.artist, resource)
  end

  def can_be_updated?
    abilities.allow?(:write_event, resource.artist)
  end

  def can_be_deleted?
    can_be_updated?
  end
end
