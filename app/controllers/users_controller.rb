class UsersController < ApplicationController
  def index
		@users = cruder.index
  end

  def show
		@user = cruder.show
    @membership = Membership.new
    @membership.user = @user
  end

  def new
		@user = cruder.new
  end

  def edit
		@user = cruder.edit
  end

	def edit_password
		@user = cruder.edit
	end

	def update
    redirect_to admin_user_url(cruder.update)
  rescue Resource::InvalidResource => e
    @user = e.cruder
    render action: (request.referrer == admin_edit_password_url(@user) ?
      'edit_password' : 'edit')
	end

	def create
    redirect_to admin_user_url(cruder.create)
  rescue Resource::InvalidResource => e
    @user = e.cruder
    render :action => 'new'
	end

	def destroy
		user = cruder.destroy
    redirect_to (user == current_user ? root_url : admin_users_url)
	end

  private

  def cruder
    UserCruder.new(abilities, params)
  end
end
