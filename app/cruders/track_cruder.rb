# Provides access to video resource.
class TrackCruder < Cruder
  def resource_class
    Track
  end

  def presenter_class
    TrackPresenter
  end

  def resource_scope
    owner.tracks
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
