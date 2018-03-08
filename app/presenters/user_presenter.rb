# frozen_string_literal: true

class UserPresenter < Presenter
  def_delegators(:resource,
                 :login, :email, :admin?, :publisher?,
                 :created_at, :updated_at,
                 :login_count, :failed_login_count, :last_login_at,
                 :memberships, :other_artists)

  alias user resource

  def path
    admin_user_path(user)
  end

  def edit_path
    edit_admin_user_path(user)
  end

  def _new_path
    new_admin_user_path(user)
  end

  def edit_password_path
    admin_edit_password_path(user)
  end
end
