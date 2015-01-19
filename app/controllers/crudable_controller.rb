module CrudableController
  extend ActiveSupport::Concern

  def index
    @presenters = presenter_class.presenters_for(cruder.index, abilities)
  end

  def show
    @presenter = build_presenter(cruder.show)
  end

  def edit
    @presenter = build_presenter(cruder.edit)
    render edit_view
  end

  def new
    @presenter = build_presenter(cruder.new)
  end

  def update
    redirect_update(cruder.update)
  rescue Cruder::InvalidResource => e
    @presenter = build_presenter(e.resource)
    render edit_view
  end

  def create
    redirect_create(cruder.create)
  rescue Cruder::InvalidResource => e
    @presenter = build_presenter(e.resource)
    render new_view
  end

  def destroy
    redirect_destroy(cruder.destroy)
  end

  protected

  def presenter_class
  end

  def cruder
  end

  def edit_view
    'edit'
  end

  def new_view
    'new'
  end

  private

  def build_presenter(obj)
    presenter_class.new(obj, abilities)
  end
end
