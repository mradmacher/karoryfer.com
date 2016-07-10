class CurrentUserController < ApplicationController
  include CrudableController

  before_action do
    user = User.find(params[:user_id])
    @user_presenter = UserPresenter.new(user)
  end
end
