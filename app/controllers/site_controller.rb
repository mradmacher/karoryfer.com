class SiteController < ApplicationController
  def home
    @current_posts = Post.some.published
    @current_events = Event.some.current.published
    @albums = Album.published
    @artists = Artist.order( :name )
  end
end
