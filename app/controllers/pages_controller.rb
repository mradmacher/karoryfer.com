class PagesController < CurrentArtistController
  layout :set_layout

  private

  def destroy_redirect_path(obj)
    artist_url(current_artist)
  end

  def cruder
    PageCruder.new(abilities, params, current_artist)
  end
end
