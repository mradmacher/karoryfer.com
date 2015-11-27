class ReleasesController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = cruder.new
    super
  end

  protected

  def new_view
    'index'
  end

  def edit_view
    'edit'
  end

  private

  def create_redirect_path(_)
    artist_album_releases_url(current_artist, current_album)
  end

  def destroy_redirect_path(_)
    artist_album_releases_url(current_artist, current_album)
  end

  def cruder
    ReleaseCruder.new(abilities, params, current_album)
  end
end
