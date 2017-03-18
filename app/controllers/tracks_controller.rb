class TracksController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = decorate(cruder.new)
    super
  end

  def show
    redirect_to cruder.show.file.url
  end

  protected

  def new_view
    'index'
  end

  def edit_view
    'edit'
  end

  def create_redirect_path(_)
    artist_album_tracks_url(current_artist, current_album)
  end

  def update_redirect_path(_)
    artist_album_tracks_url(current_artist, current_album)
  end

  def destroy_redirect_path(_)
    artist_album_tracks_url(current_artist, current_album)
  end

  def cruder
    TrackCruder.new(policy, params, current_album)
  end
end
