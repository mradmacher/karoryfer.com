class TracksController < CurrentAlbumController
  layout :set_layout

  def show
    track = resource.show
    redirect_to track.file.url
  end

  def new
    @track = resource.new
  end

  def edit
		@track = resource.edit
  end

  def create
    resource.create
    redirect_to artist_album_url(current_artist, current_album)
  rescue Resource::InvalidResource => e
		@track = e.resource
    render :action => 'new'
  end

	def update
    resource.update
    redirect_to artist_album_url(current_artist, current_album)
  rescue Resource::InvalidResource => e
		@post = e.resource
    render :action => 'edit'
	end

  def destroy
    resource.destroy
    redirect_to artist_album_url(current_artist, current_album)
  end

  protected

  def resource
    Resource::TrackResource.new(abilities, params, current_album)
  end
end
