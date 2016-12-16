class AlbumsController < CurrentArtistController
  layout :set_layout

  def download
    @artist = Artist.find_by_reference(params[:artist_id])
    @album = @artist.albums.find_by_reference(params[:id])
    release = @album.releases.in_format(params[:format]).first!
    if release.url
      release.increment!(:downloads)
      redirect_to release.url
    else
      redirect_to artist_album_url(@artist, @album)
    end
  end

  private

  def destroy_redirect_path(_)
    artist_albums_url(current_artist)
  end

  def cruder
    AlbumCruder.new(params, policy, current_artist)
  end
end
