class SimpleCruder < Cruder
  def save(resource)
    resource.save
  end

  def delete(resource)
    resource.delete
  end

  def assign(resource)
    resource.assign_attributes(permitted_params)
  end
end
