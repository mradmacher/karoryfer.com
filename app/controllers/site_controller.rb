class SiteController < ApplicationController
  before_filter :require_user, only: [:drafts]
  before_filter :set_resources

  def home
    @albums = Album.published
    @artists = Artist.order( :name )
  end

  def albums
		@albums = Album.published.all
  end

  def events
    @current_date = "#{params[:day]}/#{params[:month]}/#{params[:year]}"
    @events = Event.published

    if params[:day] && params[:month] && params[:year]
      @events = @events.for_day( params[:year], params[:month], params[:day] )
    elsif params[:month] && params[:year]
      @events = @events.for_month( params[:year], params[:month] )
    elsif params[:year]
      @events = @events.for_year( params[:year] )
    end
  end

  def posts
    @selected_year = "#{params[:year]}"
    @posts = Post.published
    @posts = @posts.created_in_year( params[:year] ) if params[:year]
  end

  def videos
    @videos = Video.all
  end

  def drafts
    @events = current_user.unpublished_events
    @posts = current_user.unpublished_posts
    @albums = current_user.unpublished_albums
  end

  private
  def set_resources
    @current_posts = Post.some.published
    @current_events = Event.some.current.published
    @current_videos = Video.some
  end
end

