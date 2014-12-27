class CurrentArtistController < ApplicationController
  before_filter do
    @current_artist_presenter = ArtistPresenter.new(current_artist, abilities)
  end

  def index
    @presenters = presenter_class.presenters_for(cruder.index, abilities)
  end

  def show
    @presenter = presenter_class.new(cruder.show, abilities)
  end

  def edit
    @presenter = presenter_class.new(cruder.edit, abilities)
    render edit_view
  end

  def new
		@presenter = presenter_class.new(cruder.new, abilities)
  end

	def update
    redirect_update(cruder.update)
  rescue Cruder::InvalidResource => e
    @presenter = presenter_class.new(e.resource, abilities)
    render edit_view
	end

	def create
    redirect_create(cruder.create)
  rescue Cruder::InvalidResource => e
		@presenter = presenter_class.new(e.resource, abilities)
    render new_view
	end

	def destroy
    redirect_destroy(cruder.destroy)
	end

  protected

  def edit_view
    'shared/edit'
  end

  def new_view
    'new'
  end
end
