class PagesController < CurrentArtistController
  layout :set_layout

  def new
		@page = resource.new
  end

	def create
    redirect_to artist_page_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
    @page = e.resource
    render :action => "new"
	end

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

  def view_class
    PageView
  end

  def resource
    Resource::PageResource.new(abilities, params, current_artist)
  end
end
