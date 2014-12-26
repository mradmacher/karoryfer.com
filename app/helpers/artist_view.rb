class ArtistView < ResourceView
  def_delegators(:resource, :name, :summary, :image?, :image)

  alias :artist :resource

  def _path
    artist_path(resource)
  end

  def _edit_path
    edit_artist_path(resource)
  end

  def new_page_path
    new_artist_page_path(artist) if can_create_pages?
  end

  def new_event_path
    new_artist_event_path(artist) if can_create_events?
  end

  def new_post_path
    new_artist_post_path(artist) if can_create_posts?
  end

  def new_video_path
    new_artist_video_path(artist) if can_create_videos?
  end

  def new_album_path
    new_artist_album_path(artist) if can_create_albums?
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
    @recent_pages ||= PageView.views_for(artist.pages.some, abilities)
  end

  def recent_events
    @recent_events ||= EventView.views_for(artist.events.current, abilities)
  end

  def recent_posts
    @recent_posts ||= PostView.views_for(artist.posts.some, abilities)
  end

  def recent_videos
    @recent_videos ||= VideoView.views_for(artist.videos.some, abilities)
  end

  def recent_albums
    @recent_albums ||= AlbumView.views_for(artist.albums.published, abilities)
  end


  def events_count
    artist.events.current.count
  end

  def posts_count
    artist.posts.count
  end

  def videos_count
    artist.videos.count
  end

  def albums_count
    artist.albums.published.count
  end


  def show_pages?
    !recent_pages.empty?
  end

  def show_events?
    !artist.events.empty?
  end

  def show_posts?
    !recent_posts.empty?
  end

  def show_videos?
    !recent_videos.empty?
  end

  def show_albums?
    !recent_albums.empty?
  end

  def show_recent_pages?
    !recent_pages.empty? or can_create_pages?
  end

  def show_recent_events?
    !artist.events.current.empty? or can_create_events?
  end

  def show_recent_posts?
    !recent_posts.empty? or can_create_posts?
  end

  def show_recent_videos?
    !recent_videos.empty? or can_create_videos?
  end

  def show_recent_albums?
    !recent_albums.empty? or can_create_albums?
  end

  private

  def can_create_pages?
    abilities.allow?(:write, Page, artist)
  end

  def can_create_events?
    abilities.allow?(:write, Event, artist)
  end

  def can_create_posts?
    abilities.allow?(:write, Post, artist)
  end

  def can_create_videos?
    abilities.allow?(:write, Video, artist)
  end

  def can_create_albums?
    abilities.allow?(:write, Album, artist)
  end
end
