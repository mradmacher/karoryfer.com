class CurrentArtistView
  include Rails.application.routes.url_helpers

  attr_reader :artist, :abilities

  def initialize(artist, abilities)
    @artist = artist
    @abilities = abilities
  end

  def new_page_path
    new_artist_page_path(artist)
  end

  def new_event_path
    new_artist_event_path(artist)
  end

  def new_post_path
    new_artist_post_path(artist)
  end

  def new_video_path
    new_artist_video_path(artist)
  end

  def new_album_path
    new_artist_album_path(artist)
  end

  def page_path(page)
    artist_page_path(artist, page)
  end

  def event_path(event)
    artist_event_path(artist, event)
  end

  def post_path(post)
    artist_post_path(artist, post)
  end

  def video_path(video)
    artist_video_path(artist, video)
  end

  def album_path(album)
    artist_album_path(artist, album)
  end

  def events_path
    artist_events_path(artist)
  end

  def posts_path
    artist_posts_path(artist)
  end

  def videos_path
    artist_videos_path(artist)
  end

  def albums_path
    artist_albums_path(artist)
  end

  def recent_pages
    artist.pages
  end

  def recent_events
    artist.events.current
  end

  def current_events_count
    artist.events.current.count
  end

  def expired_events_count
    artist.events.expired.count
  end

  def recent_posts
    artist.posts.some
  end

  def posts_count
    artist.posts.count
  end

  def recent_videos
    artist.videos.some
  end

  def videos_count
    artist.videos.count
  end

  def recent_albums
    artist.albums.published
  end

  def albums_count
    artist.albums.published.count
  end

  def show_pages?
    !recent_pages.empty? or create_pages?
  end

  def show_events?
    !artist.events.empty? or create_events?
  end

  def show_posts?
    !recent_posts.empty? or create_posts?
  end

  def show_videos?
    !recent_videos.empty? or create_videos?
  end

  def show_albums?
    !recent_albums.empty? or create_albums?
  end

  def create_pages?
    abilities.allow?(:write, Page, artist)
  end

  def create_events?
    abilities.allow?(:write, Event, artist)
  end

  def create_posts?
    abilities.allow?(:write, Post, artist)
  end

  def create_videos?
    abilities.allow?(:write, Video, artist)
  end

  def create_albums?
    abilities.allow?(:write, Album, artist)
  end
end

