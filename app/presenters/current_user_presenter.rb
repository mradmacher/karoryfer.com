# frozen_string_literal: true

class CurrentUserPresenter < Presenter
  def_delegators(:resource, :admin?, :publisher?)

  alias current_user resource

  def unpublished_albums
    resource.persisted? ? Album.unpublished : []
  end

  def account_path
    admin_user_path(current_user)
  end

  def logout_path
    admin_logout_path
  end

  def login_path
    admin_login_path
  end
end
