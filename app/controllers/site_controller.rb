class SiteController < ApplicationController
  def home
    @current_posts = Post.some.published
    date = Date.today
    @current_events = Event.current.for_month( date.year, date.month ).published
    @videos = Video.some
    @albums = Album.some.published
  end
end
