class PostsController < CurrentArtistController
  layout :set_layout

  private

  def redirect_update(obj)
    redirect_to artist_post_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_posts_url(current_artist)
  end

  def redirect_create(obj)
    redirect_to artist_post_url(current_artist, obj)
  end

  def cruder
    PostCruder.new(abilities, params, current_artist)
  end
end
