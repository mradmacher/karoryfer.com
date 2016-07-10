class PagesController < CurrentArtistController
  layout :set_layout

  private

  def destroy_redirect_path(_)
    artist_url(current_artist)
  end

  def cruder
    PageCruder.new(params, policy, current_artist)
  end
end
