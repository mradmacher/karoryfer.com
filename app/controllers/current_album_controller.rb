class CurrentAlbumController < CurrentArtistController
  before_action do
    @album_presenter = AlbumPresenter.new(current_album, abilities)
  end

  protected

  def current_album
    current_artist.albums.find_by_reference(params[:album_id])
  end
end
