# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @presenters = UserPresenter.presenters_for(cruder.index)
  end

  def show
    @presenter = UserPresenter.new(cruder.show)
    @membership = Membership.new
    @membership.user = @presenter.resource
  end

  def edit_password
    @presenter = UserPresenter.new(cruder.edit)
  end

  def edit
    @presenter = UserPresenter.new(cruder.edit)
    render edit_view
  end

  def new
    @presenter = UserPresenter.new(cruder.new)
    render :new
  end

  def update
    redirect_to UserPresenter.new(cruder.update).path
  rescue Crudable::InvalidResource => e
    @presenter = UserPresenter.new(e.resource)
    render :edit
  end

  def create
    redirect_to UserPresenter.new(cruder.create).path
  rescue Crudable::InvalidResource => e
    @presenter = UserPresenter.new(e.resource)
    render :new
  end

  def destroy
    redirect_to UserPresenter.new(cruder.destroy) == current_user ? root_url : admin_users_url
  end

  private

  def edit_view
    if request.referrer == admin_edit_password_url(@presenter.resource)
      'edit_password'
    else
      'edit'
    end
  end

  def policy_class
    UserPolicy
  end

  def cruder
    UserCruder.new(policy_class.new(current_user.resource), params)
  end
end
