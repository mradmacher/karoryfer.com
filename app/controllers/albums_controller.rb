class AlbumsController < CurrentArtistController
  layout :set_layout

  def index
		@albums = (can?(:write, Album, current_artist) ? resource.index : resource.index.published)
  end

  def show
		@album = resource.show
    @current_view = AlbumView.new(@album, abilities)
  end

  def edit
		@album = resource.edit
    @current_view = AlbumView.new(@album, abilities)
    render 'shared/edit'
  end

  def new
    @album = resource.new
  end

	def create
    redirect_to artist_album_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
    @album = e.resource
    render :action => 'new'
	end

	def update
    redirect_to artist_album_url(current_artist, resource.update)
  rescue Resource::InvalidResource => e
    @album = e.resource
    render :action => 'edit'
	end

	def destroy
		resource.destroy
		redirect_to artist_albums_url(current_artist)
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

  def resource
    Resource::AlbumResource.new(abilities, params, current_artist)
  end
end
