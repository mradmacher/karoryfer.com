require 'singleton'

class Publisher
  include Singleton
  attr_accessor :url, :name

  def host
    url.sub(%r{https?:\/\/}, '')
  end
end
