class CurrentUserController < ApplicationController
  include CrudableController

  before_filter do
    user = User.find(params[:user_id])
    @user_presenter = UserPresenter.new(user, abilities)
  end
end
