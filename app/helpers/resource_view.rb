class ResourceView
  include Rails.application.routes.url_helpers

  attr_reader :resource, :abilities, :owner

  def initialize(resource, abilities, owner = nil)
    @resource = resource
    @abilities = abilities
    @owner = owner
  end

  def title
    resource.title
  end

  def with_show_path
    path = show_path
    yield path  if path
  end

  def with_edit_path
    path = edit_path
    yield path if path
  end

  def with_destroy_path
    path = destroy_path
    yield path if path
  end

  def show_path
    if abilities.allow?(:read, resource)
      _path
    end
  end

  def edit_path
    if abilities.allow?(:write, resource)
      _edit_path
    end
  end

  def destroy_path
    if abilities.allow?(:write, resource)
      _path
    end
  end

  def _path
  end

  def _edit_path
  end
end
