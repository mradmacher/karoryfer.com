# frozen_string_literal: true

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

  def album_url(album)
    Rails.application.routes.url_helpers.artist_album_url(album.artist, album, host: host)
  end
end
