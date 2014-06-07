require 'singleton'

class Publisher
  include Singleton
  attr_accessor :url, :name

  def host
    url.sub(/https?:\/\//, '')
  end
end

