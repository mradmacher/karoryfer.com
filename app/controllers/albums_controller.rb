class AlbumsController < CurrentArtistController
  layout :set_layout

  def index
		@albums = current_artist.albums.published
  end

  def show
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :read, @album
  end

  def edit
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
  end

  def new
		authorize! :write, Album, current_artist
		@album = current_artist.albums.new
  end

	def create
		authorize! :write, Album, current_artist
		@album = current_artist.albums.new( album_params )
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'new'
		end
	end

	def update
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
		@album.assign_attributes( album_params )
    @album.artist = current_artist
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
		@album.destroy
		redirect_to artist_albums_url( current_artist )
	end

  def download
    @artist = Artist.find_by_reference( params[:artist_id] )
		@album = @artist.albums.find_by_reference( params[:id] )
    release = @album.releases.in_format( params[:format] ).first!
    if release.file?
      release.increment!(:downloads)
      if request.xhr?
        render json: { success: true, url: release.file.url }
      else
        redirect_to release.file.url
      end
    else
      release.generate_in_background!
      if request.xhr?
        render json: { success: false }
      else
        redirect_to artist_album_url(@artist, @album), notice: I18n.t('label.release_message')
      end
    end
  end

  private

  def album_params
    params.require(:album).permit(
      :published,
      :title,
      :reference,
      :year,
      :image,
      :remove_image,
      :license_id,
      :donation,
      :description
    )
  end
end

