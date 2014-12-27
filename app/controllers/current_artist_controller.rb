class CurrentArtistController < ApplicationController
  before_filter do
    @current_artist_presenter = ArtistPresenter.new(current_artist, abilities)
  end

  def index
    @presenters = presenter_class.presenters_for(resource.index, abilities)
  end

  def show
    @presenter = presenter_class.new(resource.show, abilities)
  end

  def edit
    @presenter = presenter_class.new(resource.edit, abilities)
    render edit_view
  end

  def new
		@presenter = presenter_class.new(resource.new, abilities)
  end

	def update
    redirect_update(resource.update)
  rescue Resource::InvalidResource => e
    @presenter = presenter_class.new(e.resource, abilities)
    render edit_view
	end

	def create
    redirect_create(resource.create)
  rescue Resource::InvalidResource => e
		@presenter = presenter_class.new(e.resource, abilities)
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
