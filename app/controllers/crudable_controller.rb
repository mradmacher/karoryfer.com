module CrudableController
  extend ActiveSupport::Concern

  def index
    @presenters = decorate_all(cruder.index)
  end

  def show
    @presenter = decorate(cruder.show)
  end

  def edit
    @presenter = decorate(cruder.edit)
    render edit_view
  end

  def new
    @presenter = decorate(cruder.new)
    render new_view
  end

  def update
    redirect_to update_redirect_path(decorate(cruder.update))
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render edit_view
  end

  def create
    redirect_to create_redirect_path(decorate(cruder.create))
  rescue Crudable::InvalidResource => e
    @presenter = decorate(e.resource)
    render new_view
  end

  def destroy
    redirect_to destroy_redirect_path(decorate(cruder.destroy))
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

  def decorate_all(objs)
    presenter_class.nil? ? objs : presenter_class.presenters_for(objs)
  end

  def decorate(obj)
    presenter_class.nil? ? obj : presenter_class.new(obj)
  end

  def model_name
    @model_name ||= self.class.name.sub('sController', '')
  end

  def presenter_class
    "#{model_name}Presenter".constantize
  end

  def policy_class
    "#{model_name}Policy".constantize
  end

  def policy
    @policy ||= policy_class.new(current_user.resource)
  end
end
