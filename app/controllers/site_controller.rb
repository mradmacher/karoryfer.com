class SiteController < ApplicationController
  before_filter :require_user, only: [:drafts]
  before_filter :set_resources

  def home
    @albums = Album.published.sample(4)
    @artists = Artist.all.sample(4)
  end

  def albums
		@albums = Album.published
  end

  def artists
		@artists = Artist.order(:name)
  end

  def events
    @current_date = "#{params[:day]}/#{params[:month]}/#{params[:year]}"
    @events = Event.all

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
    @posts = Post.all
    @posts = @posts.created_in_year( params[:year] ) if params[:year]
  end

  def videos
    @videos = Video.all
  end

  def drafts
    @albums = current_user.unpublished_albums
  end

  private
  def set_resources
    @current_posts = Post.some
    @current_events = Event.some.current
    @current_videos = Video.some
  end
end

