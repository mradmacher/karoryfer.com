# Provides access to track resource.
class TrackCruder < SimpleCruder
  alias_method :album, :context

  def list
    album.tracks
  end

  def find
    album.tracks.find(params[:id])
  end

  def build
    album.tracks.new
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
