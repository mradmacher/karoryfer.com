class SiteController < ApplicationController
  before_filter :require_user, only: [:drafts]
  before_filter :set_resources

  def home
    @album_views = AlbumView.views_for(Album.published.sample(4), abilities)
    @artist_views = ArtistView.views_for(Artist.all.sample(4), abilities)
  end

  def albums
		@album_views = AlbumView.views_for(Album.published.shared, abilities)
  end

  def artists
		@artist_views = ArtistView.views_for(Artist.order(:name), abilities)
  end

  def events
    @current_date = "#{params[:day]}/#{params[:month]}/#{params[:year]}"
    events = Event.all

    if params[:day] && params[:month] && params[:year]
      events = events.for_day( params[:year], params[:month], params[:day] )
    elsif params[:month] && params[:year]
      events = events.for_month( params[:year], params[:month] )
    elsif params[:year]
      events = events.for_year( params[:year] )
    end
    @event_views = EventView.views_for(events, abilities)
  end

  def posts
    @selected_year = "#{params[:year]}"
    posts = Post.all
    posts = posts.created_in_year( params[:year] ) if params[:year]
    @post_views = PostView.views_for(posts, abilities)
  end

  def videos
    @video_views = VideoView.views_for(Video.all, abilities)
  end

  def drafts
    @album_views = AlbumView.views_for(current_user.unpublished_albums, abilities)
  end

  private

  def set_resources
    @recent_posts = PostView.views_for(Post.some, abilities)
    @recent_events = EventView.views_for(Event.some.current, abilities)
    @recent_videos = VideoView.views_for(Video.some, abilities)
  end
end
