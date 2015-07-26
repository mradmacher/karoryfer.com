class VideoPresenter < Presenter
  def_delegators(:resource, :title, :body, :url, :artist)

  def path
    artist_video_path(resource.artist, resource)
  end

  def edit_path
    edit_artist_video_path(resource.artist, resource)
  end

  def embed_url
    "http://www.youtube-nocookie.com/embed/#{identifier}" if identifier
  end

  def image_url
    "http://img.youtube.com/vi/#{identifier}/2.jpg" if identifier
  end

  def can_be_updated?
    abilities.allow?(:write_video, resource.artist)
  end

  def can_be_deleted?
    can_be_updated?
  end

  private

  def identifier
    match = resource.url.match( /youtu\.be\/(.*)/ )
    return match[1] if match && match.size > 1
  end
end
