class UsersController < ApplicationController
  def index
		@users = resource.index
  end

  def show
		@user = resource.show
    @membership = Membership.new
    @membership.user = @user
  end

  def new
		@user = resource.new
  end

  def edit
		@user = resource.edit
  end

	def edit_password
		@user = resource.edit
	end

	def update
    redirect_to admin_user_url(resource.update)
  rescue Resource::InvalidResource => e
    @user = e.resource
    render action: (request.referrer == admin_edit_password_url(@user) ?
      'edit_password' : 'edit')
	end

	def create
    redirect_to admin_user_url(resource.create)
  rescue Resource::InvalidResource => e
    @user = e.resource
    render :action => 'new'
	end

	def destroy
		user = resource.destroy
    redirect_to (user == current_user ? root_url : admin_users_url)
	end

  private

  def resource
    Resource::UserResource.new(abilities, params)
  end
end
