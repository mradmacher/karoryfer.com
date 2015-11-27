class AccountPresenter < Presenter
  def_delegators(:resource,
                 :login,
                 :email,
                 :admin?,
                 :publisher?,
                 :created_at,
                 :updated_at,
                 :login_count,
                 :failed_login_count,
                 :last_login_at,
                 :memberships)

  def path
    admin_account_path
  end

  def edit_path
    edit_admin_account_path
  end

  def edit_password_path
    password_admin_account_path
  end
end
