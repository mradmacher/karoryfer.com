class PagesController < CurrentArtistController
  layout :set_layout

  private

  def redirect_update(obj)
    redirect_to artist_page_url(current_artist, obj)
  end

  def redirect_create(obj)
    redirect_to artist_page_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_url(current_artist)
  end

  def presenter_class
    PagePresenter
  end

  def resource
    Resource::PageResource.new(abilities, params, current_artist)
  end
end
