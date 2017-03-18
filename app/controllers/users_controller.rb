class UsersController < ApplicationController
  include CrudableController

  def show
    @presenter = decorate(cruder.show)
    @membership = Membership.new
    @membership.user = @presenter.resource
  end

  def edit_password
    @presenter = decorate(cruder.edit)
  end

  private

  def edit_view
    if request.referrer == admin_edit_password_url(@presenter.resource)
      'edit_password'
    else
      'edit'
    end
  end

  def destroy_redirect_path(obj)
    obj == current_user ? root_url : admin_users_url
  end

  def cruder
    UserCruder.new(policy, params)
  end
end
