module Resource
  # Provides access to post resource.
  class PostResource < RegularResource

    protected

    def resource_class
      Post
    end

    def resource_scope
      owner.posts
    end

    def permitted_params
      strong_parameters.require(:post).permit(
        :title,
        :body
      )
    end
  end
end

