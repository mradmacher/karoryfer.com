class ArtistsController < CurrentArtistController
  layout 'current_artist', :except => [:index, :new, :create]

  def show
		@artist = Artist.find_by_reference( params[:id] )
  end

  def index
		@artists = Artist.all( :order => 'name' )
  end

  def new
		authorize! :write, Artist
		@artist = Artist.new
  end

  def edit
		@artist = Artist.find_by_reference( params[:id] )
		authorize! :write, @artist
  end

	def create
		@artist = Artist.new( artist_params )
		authorize! :write, @artist
		if @artist.save
			redirect_to artist_url( @artist )
		else
			render :action => "new"
		end
	end

	def update
		@artist = Artist.find_by_reference( params[:id] )
		authorize! :write, @artist

		if @artist.update_attributes( artist_params )
			redirect_to artist_url( @artist )
		else
			render :action => "edit"
		end
	end

  private

  def artist_params
    params.require(:artist).permit(
      :name,
      :reference,
      :summary,
      :image,
      :remove_image,
      :description
    )
  end
end

