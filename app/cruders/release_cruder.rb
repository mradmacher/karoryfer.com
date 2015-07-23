# Provides access to release resource.
class ReleaseCruder < Cruder
  def resource_class
    Release
  end

  def presenter_class
    ReleasePresenter
  end

  def resource_scope
    owner.releases
  end

  def permitted_params
    strong_parameters.require(:release).permit(:album_id, :format, :file)
  end
end
