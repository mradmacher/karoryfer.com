class MembershipsController < ApplicationController
	def create
		@membership = Membership.new( membership_params )
		authorize! :write, @membership
		@membership.save
    redirect_to admin_user_url( @membership.user )
	end

	def destroy
		@membership = Membership.find( params[:id] )
		authorize! :write, @membership
		@membership.destroy
    redirect_to admin_user_url( @membership.user )
	end

  private

  def membership_params
    params.require(:membership).permit!
  end
end

