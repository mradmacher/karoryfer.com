class ArtistsController < CurrentArtistController
  layout 'current_artist', :except => [:index, :new, :create]

  private

  def edit_view
    'edit'
  end

  def redirect_update(obj)
    redirect_to artist_url(obj)
  end

  def redirect_create(obj)
    redirect_to artist_url(obj)
  end

  def redirect_destroy(obj)
    redirect_to artists_url
  end

  def presenter_class
    ArtistPresenter
  end

  def cruder
    ArtistCruder.new(abilities, params)
  end
end
