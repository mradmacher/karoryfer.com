class Cruder
  attr_reader :params, :policy, :context

  class InvalidResource < StandardError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end
  end

  def initialize(params, policy, context = nil)
    @params = params
    @policy = policy
    @context = context
  end

  def index
    authorize policy.read_access?
    list
  end

  def show
    authorize policy.read_access?
    find.tap { |resource| authorize policy.read?(resource) }
  end

  def new
    authorize policy.write_access?
    # build.tap { |resource| authorize policy.write?(resource) }
    build
  end

  def edit
    authorize policy.write_access?
    find.tap { |resource| authorize policy.write?(resource) }
  end

  def create
    authorize policy.write_access?
    build.tap do |resource|
      assign(resource)
      # authorize policy.write?(resource)
      validate(resource) { |r| save(r) }
    end
  end

  def update
    authorize policy.write_access?
    find.tap do |resource|
      assign(resource)
      authorize policy.write?(resource)
      validate(resource) { |r| save(r) }
    end
  end

  def destroy
    authorize policy.write_access?
    find.tap do |resource|
      authorize policy.write?(resource)
      validate(resource) { |r| delete(r) }
    end
  end

  protected

  def save
    fail 'write me'
  end

  def delete
    fail 'write me'
  end

  def list
    fail 'write me'
  end

  def find
    fail 'write me'
  end

  def build
    fail 'write me'
  end

  def assign(_resource)
    fail 'write me'
  end

  def model_name
    @model_name ||= self.class.name.sub('Cruder', '')
  end

  def authorize(permitted)
    fail User::AccessDenied unless permitted
  end

  def strong_parameters
    ActionController::Parameters.new(params)
  end

  def permitted_params
    strong_parameters
  end

  def validate(resource)
    fail InvalidResource, resource unless yield resource
  end
end
