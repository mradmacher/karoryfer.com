class AlbumsController < CurrentArtistController
  layout :set_layout

  def download
    @artist = Artist.find_by_reference(params[:artist_id])
    @album = @artist.albums.find_by_reference(params[:id])
    release = @album.releases.in_format(params[:format]).first!
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

  def destroy_redirect_path(_)
    artist_albums_url(current_artist)
  end

  def cruder
    AlbumCruder.new(abilities, params, current_artist)
  end
end
