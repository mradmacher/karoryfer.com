class ArtistsController < CurrentArtistController
  layout 'current_artist', :except => [:index, :new, :create]

  private

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

  def resource
    Resource::ArtistResource.new(abilities, params)
  end

  def edit_view
    'edit'
  end

  def new_vew
    'new'
  end
end
