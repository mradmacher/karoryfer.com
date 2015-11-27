class MembershipsController < CurrentUserController
  private

  def create_redirect_path(obj)
    admin_user_url(obj.user)
  end

  def destroy_redirect_path(obj)
    admin_user_url(obj.user)
  end

  def cruder
    MembershipCruder.new(abilities, params, @user_presenter.resource)
  end
end
