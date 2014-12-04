module Resource
  # Provides access to post resource.
  class PostResource < RegularResource
    def resource_class
      Post
    end

    def permitted_params
      strong_parameters.require(:post).permit(
        :title,
        :body
      )
    end

    protected

    def resource_scope
      owner.posts
    end
  end
end
