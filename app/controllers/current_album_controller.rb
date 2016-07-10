class CurrentAlbumController < CurrentArtistController
  helper_method :album

  protected

  def album
    @album_presenter ||= AlbumPresenter.new(current_album)
  end

  def current_album
    current_artist.albums.find_by_reference(params[:album_id])
  end
end
