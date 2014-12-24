class EventsController < CurrentArtistController
  layout :set_layout

  respond_to :json, :only => [:calendar]

  def index
    @events = resource.index
  end

  def calendar
    grouped_events = Event.for_month( params[:ano], params[:mes] ).each_with_object({}) do |e, result|
      result[e.event_date] = [] unless result.has_key? e.event_date
      result[e.event_date] << e.artist.name
    end
    result = []
    grouped_events.each do |event_date, artists|
      result << [event_date.strftime( '%-d/%-m/%Y' ), artists.uniq.join( ', ' ),
        events_from_path( :month => event_date.month, :year => event_date.year, :day => event_date.day )]
    end
    respond_with result.to_json
  end

  private

  def redirect_update(obj)
    redirect_to artist_event_url(current_artist, obj)
  end

  def redirect_create(obj)
    redirect_to artist_event_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_events_url(current_artist)
  end

  def view_class
    EventView
  end

  def resource
    Resource::EventResource.new(abilities, params, current_artist)
  end
end
