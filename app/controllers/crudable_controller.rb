module CrudableController
  extend ActiveSupport::Concern

  def index
    @presenters = cruder.index
  end

  def show
    @presenter = cruder.show
  end

  def edit
    @presenter = cruder.edit
    render edit_view
  end

  def new
    @presenter = cruder.new
  end

  def update
    redirect_to update_redirect_path(cruder.update)
  rescue Cruder::InvalidResource => e
    @presenter = e.resource
    render edit_view
  end

  def create
    redirect_to create_redirect_path(cruder.create)
  rescue Cruder::InvalidResource => e
    @presenter = e.resource
    render new_view
  end

  def destroy
    redirect_to destroy_redirect_path(cruder.destroy)
  end

  protected

  def cruder
  end

  def edit_view
    'edit'
  end

  def new_view
    'new'
  end

  def update_redirect_path(presenter)
    presenter.path
  end

  def create_redirect_path(presenter)
    presenter.path
  end
end
