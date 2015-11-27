class VideosController < CurrentArtistController
  layout :set_layout

  private

  def destroy_redirect_path(_)
    artist_videos_url(current_artist)
  end

  def cruder
    VideoCruder.new(abilities, params, current_artist)
  end
end
