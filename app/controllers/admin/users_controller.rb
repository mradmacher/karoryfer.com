# frozen_string_literal: true

class Admin::UsersController < AdminController
  def index
    @presenters = UserPresenter.presenters_for(User.all)
  end

  def show
    @presenter = UserPresenter.new(find)
  end

  def edit_password
    @presenter = UserPresenter.new(find)
  end

  def edit
    @presenter = UserPresenter.new(find)
    render edit_view
  end

  def new
    @presenter = UserPresenter.new(build)
    render :new
  end

  def update
    user = find.tap { |u| u.assign_attributes(user_params) }
    @presenter = UserPresenter.new(user)
    if user.save
      redirect_to @presenter.path
    else
      render :edit
    end
  end

  def create
    user = build.tap { |u| u.assign_attributes(user_params) }
    @presenter = UserPresenter.new(user)
    if user.save
      redirect_to @presenter.path
    else
      render :new
    end
  end

  def destroy
    user = find
    user.destroy
    redirect_to user == current_user ? root_url : admin_users_url
  end

  private

  def edit_view
    if request.referrer == admin_edit_password_url(@presenter.resource)
      'edit_password'
    else
      'edit'
    end
  end

  def find
    User.find(params[:id])
  end

  def build
    User.new
  end

  def user_params
    params.require(:user).permit(%i[login email password password_confirmation])
  end
end
