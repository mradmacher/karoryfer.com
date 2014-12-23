class VideosController < CurrentArtistController
  layout :set_layout

  def index
    @videos = resource.index
  end

  def new
		@video = resource.new
  end

	def create
    redirect_to artist_video_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
		@video = e.resource
    render :action => 'new'
	end

  private

  def redirect_update(obj)
    redirect_to artist_video_url(current_artist, obj)
  end

  def redirect_create(obj)
    redirect_to artist_video_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_videos_url(current_artist)
  end

  def view_class
    VideoView
  end

  def resource
    Resource::VideoResource.new(abilities, params, current_artist)
  end
end
