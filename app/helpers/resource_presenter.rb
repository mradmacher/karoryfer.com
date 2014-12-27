require 'forwardable'

class ResourcePresenter
  extend Forwardable
  include Rails.application.routes.url_helpers

  attr_reader :resource, :abilities

  def initialize(resource, abilities)
    @resource = resource
    @abilities = abilities
  end

  def self.presenters_for(collection, abilities)
    collection.map { |resource| self.new(resource, abilities) }
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

  def method_missing(m, *args, &block)
    if m =~ /with_(.*_path)/
      method = $1
      path = send(method)
      yield path if path
    else
      super
    end
  end

  def _path
  end

  def _edit_path
  end
end
