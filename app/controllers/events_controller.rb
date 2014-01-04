class EventsController < ApplicationController
	before_filter :require_user, :except => [:index, :show, :calendar]
  layout :set_layout

  respond_to :json, :only => [:calendar]

  def index
    @current_date = "#{params[:day]}/#{params[:month]}/#{params[:year]}"

    @events = current_artist?? current_artist.events.published : Event.published
    if params[:day] && params[:month] && params[:year]
      @events = @events.for_day( params[:year], params[:month], params[:day] )
    elsif params[:month] && params[:year]
      @events = @events.for_month( params[:year], params[:month] )
    elsif params[:year]
      @events = @events.for_year( params[:year] )
    end
    render :index
  end

  def drafts
		raise User::AccessDenied unless current_user?
    @category = :drafts
    @events = current_user.unpublished_events
    render :index
  end

  def calendar
    grouped_events = Event.published.for_month( params[:ano], params[:mes] ).each_with_object({}) do |e, result|
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
		@event = current_artist.events.find( params[:id] )
		authorize! :read_event, @event
  end

  def new
		@event = Event.new
		@event.artist = current_artist
		authorize! :write_event, @event
  end

  def edit
		@event = current_artist.events.find( params[:id] )
		authorize! :write_event, @event
  end

	def create
		@event = current_artist.events.new( params[:event] )
		authorize! :write_event, @event
		if @event.save
			redirect_to artist_event_url( @event.artist, @event )
		else
			render :action => 'new'
		end
	end

	def update
		@event = current_artist.events.find( params[:id] )
    @event.assign_attributes( params[:event] )
    @event.artist = current_artist
		authorize! :write_event, @event

		if @event.save
			redirect_to artist_event_url( @event.artist, @event )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@event = current_artist.events.find( params[:id] )
		authorize! :write_event, @event
		@event.destroy
    redirect_to artist_events_url( @event.artist )
	end
end

