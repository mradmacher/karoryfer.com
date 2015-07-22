class VideosController < CurrentArtistController
  layout :set_layout

  private

  def redirect_update(obj)
    redirect_to artist_video_url(current_artist, obj)
  end

  def redirect_create(obj)
    redirect_to artist_video_url(current_artist, obj)
  end

  def redirect_destroy(obj)
    redirect_to artist_videos_url(current_artist)
  end

  def cruder
    VideoCruder.new(abilities, params, current_artist)
  end
end
