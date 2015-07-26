# Provides access to video resource.
class VideoCruder < SimpleCruder
  attr_reader :artist

  def initialize(abilities, params, artist)
    super(abilities, params)
    @artist = artist
  end

  def find
    artist.videos.find(params[:id])
  end

  def build(attrs = {})
    artist.videos.new(attrs)
  end

  def search
    artist.videos
  end

  def permissions(action)
    case action
      when :index then [:read_video, artist]
      when :show then [:read_video, artist]
      when :new then [:write_video, artist]
      when :edit then [:write_video, artist]
      when :create then [:write_video, artist]
      when :update then [:write_video, artist]
      when :destroy then [:write_video, artist]
    end
  end

  def permitted_params
    strong_parameters.require(:video).permit(
      :title,
      :url,
      :body
    )
  end
end
