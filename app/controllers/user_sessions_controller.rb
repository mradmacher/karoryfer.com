# frozen_string_literal: true

class UserSessionsController < ApplicationController
  before_action :require_user, only: :destroy
  before_action :require_no_user, only: %i[new create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_url
    else
      render action: :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
end
