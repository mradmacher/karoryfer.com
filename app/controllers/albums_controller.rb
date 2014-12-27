class AlbumsController < CurrentArtistController
  layout :set_layout

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

  def redirect_update(obj)
    redirect_to artist_album_url(current_artist, obj)
  end

  def redirect_create(obj)
    redirect_to artist_album_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_albums_url(current_artist)
  end

  def presenter_class
    AlbumPresenter
  end

  def resource
    Resource::AlbumResource.new(abilities, params, current_artist)
  end
end
