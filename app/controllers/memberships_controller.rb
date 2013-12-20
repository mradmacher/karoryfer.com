class MembershipsController < ApplicationController
	before_filter :require_user

	def create
		@membership = Membership.new( params[:membership] )
		authorize! :write_membership, @membership
		@membership.save
    redirect_to admin_user_url( @membership.user )
	end

	def destroy
		@membership = Membership.find( params[:id] )
		authorize! :write_user, @membership
		@membership.destroy
    redirect_to admin_user_url( @membership.user )
	end
end

