# frozen_string_literal: true

class CurrentUserController < ApplicationController
  before_action do
    user = User.find(params[:user_id])
    @user_presenter = UserPresenter.new(user)
  end
end
