class TracksController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = TrackPresenter.new(cruder.new)
    @presenters = TrackPresenter.presenters_for(cruder.index)
  end

  def show
    redirect_to cruder.show.file.url
  end

  def edit
    @presenter = TrackPresenter.new(cruder.edit)
    render :edit
  end

  def new
    @presenter = TrackPresenter.new(cruder.new)
    render :index
  end

  def update
    cruder.update
    redirect_to artist_album_tracks_url(current_artist, current_album)
  rescue Crudable::InvalidResource => e
    @presenter = TrackPresenter.new(e.resource)
    render :edit
  end

  def create
    cruder.create
    redirect_to artist_album_tracks_url(current_artist, current_album)
  rescue Crudable::InvalidResource => e
    @presenter = TrackPresenter.new(e.resource)
    render :index
  end

  def destroy
    cruder.destroy
    redirect_to artist_album_tracks_url(current_artist, current_album)
  end

  def cruder
    TrackCruder.new(TrackPolicy.new(current_user.resource), params, current_album)
  end
end
