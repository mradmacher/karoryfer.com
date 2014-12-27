# Provides access to video resource.
class VideoCruder < Cruder
  def resource_class
    Video
  end

  def permitted_params
    strong_parameters.require(:video).permit(
      :title,
      :url,
      :body
    )
  end

  protected

  def resource_scope
    owner.videos
  end
end
