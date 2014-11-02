class UsersController < ApplicationController
  def index
		authorize! :read, User
		@users = User.all
  end

  def show
		@user = User.find( params[:id] )
		authorize! :read, @user
    @membership = Membership.new
    @membership.user = @user
  end

  def new
		@user = User.new
		authorize! :write, @user
  end

  def edit
		@user = User.find( params[:id] )
		authorize! :write, @user
  end

	def edit_password
		@user = User.find( params[:id] )
		authorize! :write, @user
	end

	def update
		@user = User.find( params[:id] )
		authorize! :write, @user
		if @user.update_attributes( user_params )
			redirect_to admin_user_url( @user )
		else
			if request.referrer == admin_edit_password_url( @user ) then
				render :action => 'edit_password'
			else
				render :action => 'edit'
			end
		end
	end

	def create
		@user = User.new( params[:user] )
		authorize! :write, @user
		if @user.save
			redirect_to admin_user_url( @user )
		else
			render :action => 'new'
		end
	end

	def destroy
		@user = User.find( params[:id] )
		authorize! :write, @user
		@user.destroy
		if @user == current_user then
			redirect_to root_url
		else
			redirect_to admin_users_url
		end
	end

  private

  def user_params
    params.require(:user).permit(
      if current_user and current_user.admin?
        [:login, :email, :password, :password_confirmation, :admin, :publisher]
      else
        [:login, :email, :password, :password_confirmation]
      end
    )
  end
end

