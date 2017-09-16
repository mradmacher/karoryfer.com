class ArtistsController < CurrentArtistController
  layout 'current_artist', except: [:index, :new, :create]

  def index
    @presenters = decorate_all(cruder.index)
  end

  def show
    @presenter = decorate(cruder.show)
  end

  def edit
    @presenter = decorate(cruder.edit)
    render :edit
  end

  def new
    @presenter = decorate(cruder.new)
    render :new
  end

  def update
    redirect_to decorate(cruder.update).path
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render :edit
  end

  def create
    redirect_to decorate(cruder.create).path
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render new_view
  end

  private

  def presenter_class
    ArtistPresenter
  end

  def cruder
    ArtistCruder.new(ArtistPolicy.new(current_user.resource), params)
  end
end
