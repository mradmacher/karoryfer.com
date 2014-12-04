class VideosController < CurrentArtistController
  layout :set_layout

  def index
    @videos = resource.index
  end

  def show
		@video = resource.show
    @current_view = VideoView.new(@video, abilities)
  end

  def new
		@video = resource.new
  end

  def edit
		@video = resource.edit
    @current_view = VideoView.new(@video, abilities)
    render 'shared/edit'
  end

	def create
    redirect_to artist_video_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
		@video = e.resource
    render :action => 'new'
	end

	def update
    redirect_to artist_video_url(current_artist, resource.update)
  rescue Resource::InvalidResource => e
		@video = e.resource
    render :action => 'edit'
	end

	def destroy
    resource.destroy
    redirect_to artist_videos_url(current_artist)
	end

  private

  def resource
    Resource::VideoResource.new(abilities, params, current_artist)
  end
end
