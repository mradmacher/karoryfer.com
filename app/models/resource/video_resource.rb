module Resource
  # Provides access to video resource.
  class VideoResource < RegularResource

    protected

    def resource_class
      Video
    end

    def resource_scope
      owner.videos
    end

    def permitted_params
      strong_parameters.require(:video).permit(
        :title,
        :url,
        :body
      )
    end
  end
end


