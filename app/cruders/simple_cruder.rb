class SimpleCruder
  include Crudable
  attr_reader :params, :policy, :context

  def initialize(policy, params, context = nil)
    @params = params
    @policy = policy
    @context = context
  end

  def save(resource)
    resource.save
  end

  def delete(resource)
    resource.destroy
  end

  def assign(resource)
    resource.assign_attributes(permitted_params)
  end
end
