# Provides access to video resource.
class TrackCruder < SimpleCruder
  attr_reader :album

  def initialize(abilities, params, album)
    super(abilities, params)
    @album = album
  end

  def find
    album.tracks.find(params[:id])
  end

  def build(attrs = {})
    album.tracks.new(attrs)
  end

  def search
    album.tracks
  end

  def permissions(action)
    case action
    when :index then [:read_track, album]
    when :show then [:read_track, album]
    when :new then [:write_track, album]
    when :edit then [:write_track, album]
    when :create then [:write_track, album]
    when :update then [:write_track, album]
    when :destroy then [:write_track, album]
    end
  end

  def permitted_params
    strong_parameters.require(:track).permit(
      :artist_name,
      :title,
      :rank,
      :comment,
      :file,
      :remove_file
    )
  end
end
