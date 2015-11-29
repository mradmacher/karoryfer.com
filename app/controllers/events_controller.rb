class EventsController < CurrentArtistController
  layout :set_layout

  private

  def destroy_redirect_path(obj)
    artist_events_url(current_artist)
  end

  def cruder
    EventCruder.new(abilities, params, current_artist)
  end
end
