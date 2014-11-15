class PagesController < CurrentArtistController
  layout :set_layout

  def show
		@page = resource.show
  end

  def edit
		@page = resource.edit
  end

  def new
		@page = resource.new
  end

	def update
    redirect_to artist_page_url(current_artist, resource.update)
  rescue Resource::InvalidResource => e
    @page = e.resource
    render :action => "edit"
	end

	def create
    redirect_to artist_page_url(current_artist, resource.create)
  rescue Resource::InvalidResource => e
    @page = e.resource
    render :action => "new"
	end

	def destroy
    resource.destroy
    redirect_to artist_url(current_artist)
	end

  private

  def resource
    Resource::PageResource.new(params, abilities, current_artist)
  end
end

