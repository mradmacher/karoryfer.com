class SiteController < ApplicationController
  def home
    @current_posts = Post.some.published
    @current_events = Event.some.current.published
    @videos = Video.some
    @albums = Album.some.published
  end
end
