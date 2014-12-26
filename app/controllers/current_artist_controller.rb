class CurrentArtistController < ApplicationController
  before_filter do
    @current_artist_view = ArtistView.new(current_artist, abilities)
  end

  def index
    @views = view_class.views_for(resource.index, abilities)
  end

  def show
    @view = view_class.new(resource.show, abilities)
  end

  def edit
    @view = view_class.new(resource.edit, abilities)
    render edit_view
  end

  def new
		@view = view_class.new(resource.new, abilities)
  end

	def update
    redirect_update(resource.update)
  rescue Resource::InvalidResource => e
    @view = view_class.new(e.resource, abilities)
    render edit_view
	end

	def create
    redirect_create(resource.create)
  rescue Resource::InvalidResource => e
		@view = view_class.new(e.resource, abilities)
    render new_view
	end

	def destroy
    redirect_destroy(resource.destroy)
	end

  protected

  def edit_view
    'shared/edit'
  end

  def new_view
    'new'
  end
end
