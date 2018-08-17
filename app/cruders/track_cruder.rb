# frozen_string_literal: true

# Provides access to track resource.
class TrackCruder < SimpleCruder
  alias album context

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
      :lyrics,
      :file,
      :remove_file
    )
  end
end
