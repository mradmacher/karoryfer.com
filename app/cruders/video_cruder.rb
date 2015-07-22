# Provides access to video resource.
class VideoCruder < Cruder
  def resource_class
    Video
  end

  def presenter_class
    VideoPresenter
  end

  def permitted_params
    strong_parameters.require(:video).permit(
      :title,
      :url,
      :body
    )
  end

  def resource_scope
    owner.videos
  end
end
