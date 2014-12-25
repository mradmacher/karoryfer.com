class CurrentAlbumController < CurrentArtistController
  before_filter do
    @current_album_view = AlbumView.new(current_album, abilities)
  end

  protected

  def current_album
    current_artist.albums.find_by_reference(params[:album_id])
  end
end
