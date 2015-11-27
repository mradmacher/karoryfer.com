class Cruder
  attr_reader :abilities, :params

  class InvalidResource < StandardError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end
  end

  class ValidationError < StandardError
  end

  def initialize(abilities, params)
    @abilities = abilities
    @params = params
  end

  def index
    authorize! :index
    decorate_all(search)
  end

  def show
    authorize! :show
    decorate(find)
  end

  def new
    authorize! :new
    decorate(build)
  end

  def edit
    authorize! :edit
    decorate(find)
  end

  def create
    authorize! :create
    save(build)
  end

  def update
    authorize! :update
    save(find)
  end

  def destroy
    authorize! :destroy
    delete(find)
  end

  def presenter_class
    @presenter_class ||= self.class.name.sub('Cruder', 'Presenter').constantize
  end

  def permitted_params
    fail 'define me'
  end

  protected

  def search
  end

  def build
  end

  def find
  end

  def authorize!(action)
    fail User::AccessDenied unless abilities.allow?(*permissions(action))
  end

  def permissions
    {
      index: :read,
      show: :read,
      new: :write,
      edit: :write,
      create: :write,
      update: :write,
      destroy: :write
    }
  end

  def strong_parameters
    ActionController::Parameters.new(params)
  end

  def decorate_all(objs)
    presenter_class.nil? ? objs : presenter_class.presenters_for(objs, abilities)
  end

  def decorate(obj)
    presenter_class.nil? ? obj : presenter_class.new(obj, abilities)
  end

  private

  def save(resource)
    begin
      save_operation(resource, permitted_params)
    rescue ValidationError
      raise InvalidResource, decorate(resource)
    end
    decorate(resource)
  end

  def delete(resource)
    delete_operation(resource)
    decorate(resource)
  end
end
