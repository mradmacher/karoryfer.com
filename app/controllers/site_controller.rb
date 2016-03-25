class SiteController < ApplicationController
  before_action :require_user, only: [:drafts]
  before_action :set_resources

  def home
    @artist_presenters = ArtistPresenter.presenters_for(
      Artist.shared,
      abilities)
  end

  def albums
    @album_presenters = AlbumPresenter.presenters_for(
      Album.published.shared,
      abilities)
  end

  def artists
    @artist_presenters = ArtistPresenter.presenters_for(Artist.order(:name), abilities)
  end

  def events
    @event_presenters = EventPresenter.presenters_for(Event.all, abilities)
  end

  def posts
    @post_presenters = PostPresenter.presenters_for(Post.all, abilities)
  end

  def videos
    @video_presenters = VideoPresenter.presenters_for(Video.all, abilities)
  end

  def drafts
    @album_presenters = AlbumPresenter.presenters_for(current_user.unpublished_albums, abilities)
  end

  private

  def set_resources
    @recent_posts = PostPresenter.presenters_for(Post.some.current, abilities)
    @recent_events = EventPresenter.presenters_for(Event.some.current, abilities)
    @recent_videos = VideoPresenter.presenters_for(Video.some.current, abilities)
  end
end
