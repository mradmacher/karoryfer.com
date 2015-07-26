class PostsController < CurrentArtistController
  layout :set_layout

  private

  def destroy_redirect_path(obj)
    artist_posts_url(current_artist)
  end

  def cruder
    PostCruder.new(abilities, params, current_artist)
  end
end
