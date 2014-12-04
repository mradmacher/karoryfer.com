class CurrentAlbumController < CurrentArtistController
  before_filter :set_album

  protected

  def current_album
    current_artist.albums.find_by_reference(params[:album_id])
  end

  def set_album
    @album = current_album
  end
end
