class ArtistsController < CurrentArtistController
  layout 'current_artist', :except => [:index, :new, :create]

  def show
		@artist = resource.show
    @current_view = ArtistView.new(@artist, abilities)
  end

  def index
		@artists = resource.index
  end

  def new
		@artist = resource.new
  end

  def edit
		@artist = resource.edit
  end

	def create
    redirect_to artist_url(resource.create)
  rescue Resource::InvalidResource => e
    @artist = e.resource
    render action: 'new'
	end

	def update
    redirect_to artist_url(resource.update)
  rescue Resource::InvalidResource => e
    @artist = e.resource
    render action: 'edit'
	end

  private

  def resource
    Resource::ArtistResource.new(params, abilities)
  end
end

