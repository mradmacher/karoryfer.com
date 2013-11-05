class UsersController < ApplicationController
	before_filter :require_user

  def index
		authorize! :manage, User
		@users = User.all
  end

  def show
		@user = User.find( params[:id] )
		authorize! :read, @user
  end

  def new
		authorize! :manage, User
		@user = User.new
  end

  def edit
		@user = User.find( params[:id] )
		authorize! :update, @user
  end
	
	def edit_password
		@user = User.find( params[:id] )
		authorize! :update, @user
	end

	def update
		@user = User.find( params[:id] )
		authorize! :update, @user
		if @user.update_attributes( params[:user], :as => (current_user.admin? ? :admin : :default) )
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
		authorize! :create, User
		if @user.save
			redirect_to admin_user_url( @user )
		else
			render :action => 'new'
		end
	end

	def destroy
		@user = User.find( params[:id] )
		authorize! :destroy, @user
		@user.destroy
		if @user == current_user then
			redirect_to root_url
		else
			redirect_to admin_users_url
		end
	end

end
