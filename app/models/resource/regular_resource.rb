module Resource
  class RegularResource
    attr_reader :params, :abilities, :owner

    def initialize(abilities, params, owner = nil)
      @abilities = abilities
      @params = params
      @owner = owner
    end

    def index
      authorize! :read, resource_class, owner
      resource_scope
    end

    def show
      resource = resource_scope.send(find_method, params[:id])
      authorize! :read, resource
      resource
    end

    def new
      authorize! :write, resource_class, owner
      resource_scope.new
    end

    def edit
      resource = resource_scope.send(find_method, params[:id])
      authorize! :write, resource
      resource
    end

    def create
      authorize! :write, resource_class, owner
      resource = resource_scope.new(permitted_params)
      fail InvalidResource, resource unless resource.save
      resource
    end

    def update
      resource = resource_scope.send(find_method, params[:id])
      authorize! :write, resource

      unless resource.update_attributes(permitted_params)
        fail InvalidResource, resource
      end
      resource
    end

    def destroy
      resource = resource_scope.send(find_method, params[:id])
      authorize! :write, resource
      resource.destroy
      resource
    end
    protected

    def authorize!(action, subject, scope = nil)
      raise User::AccessDenied unless abilities.allowed?(action, subject, scope)
    end

    def strong_parameters
      ActionController::Parameters.new(params)
    end

    def resource_class
      fail 'define me'
    end

    def permitted_params
      fail 'define me'
    end

    def find_method
      :find
    end

    def resource_scope
      resource_class.all
    end
  end
end
