class SimpleCruder < Cruder
  def save_operation(resource, attrs)
    resource.assign_attributes(attrs)
    fail ValidationError unless resource.save
  end

  def delete_operation(resource)
    resource.destroy
  end
end
