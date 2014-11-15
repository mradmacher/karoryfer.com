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

  def show
		@event = resource.show
  end

  def new
		@event = resource.new
  end

  def edit
		@event = resource.edit
  end

	def create
    redirect_to artist_event_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
		@event = e.resource
    render :action => 'new'
	end

	def update
    redirect_to artist_event_url(current_artist, resource.update)
  rescue Resource::InvalidResource => e
		@event = e.resource
    render :action => 'edit'
	end

	def destroy
    resource.destroy
    redirect_to artist_events_url(current_artist)
	end

  private

  def resource
    Resource::EventResource.new(params, abilities, current_artist)
  end
end
