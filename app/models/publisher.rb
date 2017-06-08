require 'singleton'

class Publisher
  include Singleton

  def name
    'Karoryfer Lecolds'
  end

  def url
    'http://www.karoryfer.com'
  end

  def host
    url.sub(%r{https?:\/\/}, '')
  end
end
