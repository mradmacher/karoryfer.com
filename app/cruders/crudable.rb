# frozen_string_literal: true

module Crudable
  class InvalidResource < StandardError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end
  end

  def index
    authorize policy.read_access?
    list
  end

  def show
    authorize policy.read_access?
    find.tap { |resource| authorize policy.read_access_to?(resource) }
  end

  def edit
    authorize policy.write_access?
    find.tap { |resource| authorize policy.write_access_to?(resource) }
  end

  def new
    authorize policy.write_access?
    build
  end

  def create
    authorize policy.write_access?
    build.tap do |resource|
      assign(resource)
      validate(resource) { |r| save(r) }
    end
  end

  def update
    authorize policy.write_access?
    find.tap do |resource|
      authorize policy.write_access_to?(resource)
      assign(resource)
      validate(resource) { |r| save(r) }
    end
  end

  def destroy
    authorize policy.write_access?
    find.tap do |resource|
      authorize policy.write_access_to?(resource)
      delete(resource)
    end
  end

  protected

  def save
    raise 'write me'
  end

  def delete
    raise 'write me'
  end

  def list
    raise 'write me'
  end

  def find
    raise 'write me'
  end

  def build
    raise 'write me'
  end

  def assign(_resource)
    raise 'write me'
  end

  def model_name
    @model_name ||= self.class.name.sub('Cruder', '')
  end

  def authorize(permitted)
    raise User::AccessDenied unless permitted
  end

  def strong_parameters
    ActionController::Parameters.new(params)
  end

  def permitted_params
    strong_parameters
  end

  def validate(resource)
    raise InvalidResource, resource unless yield resource
  end
end
