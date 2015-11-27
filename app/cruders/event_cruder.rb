# Provides access to event resource.
class EventCruder < SimpleCruder
  attr_reader :artist

  def initialize(abilities, params, artist)
    super(abilities, params)
    @artist = artist
  end

  def find
    artist.events.find(params[:id])
  end

  def build(attrs = {})
    artist.events.new(attrs)
  end

  def search
    artist.events
  end

  def permissions(action)
    case action
    when :index then [:read_event, artist]
    when :show then [:read_event, artist]
    when :new then [:write_event, artist]
    when :edit then [:write_event, artist]
    when :create then [:write_event, artist]
    when :update then [:write_event, artist]
    when :destroy then [:write_event, artist]
    end
  end

  def permitted_params
    strong_parameters.require(:event).permit(
      :title,
      :location,
      :address,
      :event_date,
      :event_time,
      :duration,
      :free_entrance,
      :price,
      :poster,
      :remove_poster,
      :body,
      :external_urls
    )
  end
end
