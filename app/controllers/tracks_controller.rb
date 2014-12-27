class TracksController < CurrentAlbumController
  layout :set_layout

  def show
    track = cruder.show
    redirect_to track.file.url
  end

  protected

  def edit_view
    'edit'
  end

  def redirect_create(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def redirect_update(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def redirect_destroy(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def presenter_class
    TrackPresenter
  end

  def cruder
    TrackCruder.new(abilities, params, current_album)
  end
end
