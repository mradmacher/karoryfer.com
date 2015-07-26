class UsersController < ApplicationController
  include CrudableController

  def show
    @presenter = cruder.show
    @membership = Membership.new
    @membership.user = @presenter.resource
  end

  def edit_password
    @presenter = cruder.edit
  end

  private

  def edit_view
    request.referrer == admin_edit_password_url(@presenter.resource) ?
      'edit_password' : 'edit'
  end

  def destroy_redirect_path(obj)
    obj == current_user ? root_url : admin_users_url
  end

  def cruder
    UserCruder.new(abilities, params)
  end
end
