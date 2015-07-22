# Provides access to post resource.
class PostCruder < Cruder
  def resource_class
    Post
  end

  def presenter_class
    PostPresenter
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
