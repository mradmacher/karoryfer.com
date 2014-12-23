class CurrentArtistController < ApplicationController
  before_filter do
    @current_artist_view = CurrentArtistView.new(current_artist, abilities)
  end

  def show
    @view = view_class.new(resource.show, abilities)
  end

  def edit
    @view = view_class.new(resource.edit, abilities)
    render 'shared/edit'
  end

  def new
		@view = view_class.new(resource.new, abilities)
  end

	def update
    redirect_update(resource.update)
  rescue Resource::InvalidResource => e
    @view = view_class.new(e.resource, abilities)
    render 'shared/edit'
	end

	def create
    redirect_create(resource.create)
  rescue Resource::InvalidResource => e
		@view = view_class.new(e.resource, abilities)
    render action: 'new'
	end

	def destroy
    redirect_destroy(resource.destroy)
	end
end
