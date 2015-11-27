class ArtistPresenter < Presenter
  def_delegators(:resource, :name, :summary, :description, :image?, :image)

  alias_method :artist, :resource
  alias_method :title, :name

  def path
    artist_path(resource)
  end

  def edit_path
    edit_artist_path(resource)
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
    @recent_pages ||= PagePresenter.presenters_for(artist.pages.some,
                                                   abilities)
  end

  def recent_events
    @recent_events ||= EventPresenter.presenters_for(artist.events.current,
                                                     abilities)
  end

  def recent_posts
    @recent_posts ||= PostPresenter.presenters_for(artist.posts.some,
                                                   abilities)
  end

  def recent_videos
    @recent_videos ||= VideoPresenter.presenters_for(artist.videos.some,
                                                     abilities)
  end

  def recent_albums
    @recent_albums ||= AlbumPresenter.presenters_for(artist.albums.published,
                                                     abilities)
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
    !recent_pages.empty? || can_create_pages?
  end

  def show_recent_events?
    !artist.events.current.empty? || can_create_events?
  end

  def show_recent_posts?
    !recent_posts.empty? || can_create_posts?
  end

  def show_recent_videos?
    !recent_videos.empty? || can_create_videos?
  end

  def show_recent_albums?
    !recent_albums.empty? || can_create_albums?
  end

  def can_be_updated?
    abilities.allow?(:write, artist)
  end

  def can_be_deleted?
    abilities.allow?(:write, artist)
  end

  def can_create_pages?
    abilities.allow?(:write_page, artist)
  end

  def can_create_events?
    abilities.allow?(:write_event, artist)
  end

  def can_create_posts?
    abilities.allow?(:write_post, artist)
  end

  def can_create_videos?
    abilities.allow?(:write_video, artist)
  end

  def can_create_albums?
    abilities.allow?(:write_album, artist)
  end
end
