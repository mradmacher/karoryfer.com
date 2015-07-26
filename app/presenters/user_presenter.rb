class UserPresenter < Presenter
  def_delegators(:resource,
    :login, :email, :admin?, :publisher?,
    :created_at, :updated_at,
    :login_count, :failed_login_count, :last_login_at,
    :memberships, :other_artists
  )

  def path
    admin_user_path(resource)
  end

  def edit_path
    edit_admin_user_path(resource)
  end

  def _new_path
    new_admin_user_path(resource)
  end

  def edit_password_path
    admin_edit_password_path(resource)
  end
end
