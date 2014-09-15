class ArtistsController < CurrentArtistController
  layout 'current_artist', :except => [:index, :new, :create]

  def show
		@artist = Artist.find( params[:id] )
  end

  def index
		@artists = Artist.all( :order => 'name' )
  end

  def new
		authorize! :write, Artist
		@artist = Artist.new
  end

  def edit
		@artist = Artist.find( params[:id] )
		authorize! :write, @artist
  end

	def create
		@artist = Artist.new( params[:artist] )
		authorize! :write, @artist
		if @artist.save
			redirect_to artist_url( @artist )
		else
			render :action => "new"
		end
	end

	def update
		@artist = Artist.find( params[:id] )
		authorize! :write, @artist

		if @artist.update_attributes( params[:artist] )
			redirect_to artist_url( @artist )
		else
			render :action => "edit"
		end
	end
end

