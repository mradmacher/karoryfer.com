# Provides access to video resource.
class TrackCruder < Cruder

  protected

  def resource_class
    Track
  end

  def resource_scope
    owner.tracks
  end

  def permitted_params
    strong_parameters.require(:track).permit(
      :title,
      :rank,
      :comment,
      :file,
      :remove_file
    )
  end
end
