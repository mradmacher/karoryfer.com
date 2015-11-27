require 'forwardable'

class Presenter
  extend Forwardable
  include Rails.application.routes.url_helpers

  attr_reader :resource, :abilities

  def initialize(resource, abilities)
    @resource = resource
    @abilities = abilities
  end

  def self.presenters_for(collection, abilities)
    collection.map { |resource| new(resource, abilities) }
  end

  def path
  end

  def edit_path
  end
end
