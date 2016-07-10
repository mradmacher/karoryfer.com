require 'forwardable'

class Presenter
  extend Forwardable
  include Rails.application.routes.url_helpers

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def self.presenters_for(collection)
    collection.map { |resource| new(resource) }
  end

  def path
  end

  def edit_path
  end
end
