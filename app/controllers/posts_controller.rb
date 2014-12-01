class PostsController < CurrentArtistController
  layout :set_layout

  def index
    @posts = resource.index
  end

  def show
		@post = resource.show
    @current_view = PostView.new(@post, abilities)
  end

  def new
		@post = resource.new
  end

  def edit
		@post = resource.edit
    @current_view = PostView.new(@post, abilities)
    render 'shared/edit'
  end

	def create
    redirect_to artist_post_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
		@post = e.resource
    render :action => 'new'
	end

	def update
    redirect_to artist_post_url(current_artist, resource.update)
  rescue Resource::InvalidResource => e
		@post = e.resource
    render :action => 'edit'
	end

	def destroy
    resource.destroy
    redirect_to artist_posts_url(current_artist)
	end

  private

  def resource
    Resource::PostResource.new(params, abilities, current_artist)
  end
end
