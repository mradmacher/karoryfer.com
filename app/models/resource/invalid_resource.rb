module Resource
  class InvalidResource < Exception
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end
  end
end

