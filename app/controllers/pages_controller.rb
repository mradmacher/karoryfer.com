class PagesController < ApplicationController
	before_filter :require_user, :except => [:index, :show]

  def index
    redirect_to page_url( Page.first )
  end

  def show
    @pages = Page.all
		@page = Page.find( params[:id] )
  end

  def edit
		authorize! :manage, Page
		flash[:back] = request.referrer
		@page = Page.find( params[:id] )
  end

  def new
		@page = Page.new
		authorize! :create, @page
  end

	def update
		@page = Page.find( params[:id] )
		authorize! :update, @page

		if @page.update_attributes( params[:page] )
			redirect_to page_url( @page )
		else
			render :action => "edit"
		end
	end

	def create
		authorize! :create, Page
		@page = Page.new( params[:page] )
		if @page.save
			redirect_to page_url( @page )
		else
			render :action => 'new'
		end
	end

	def destroy
		@page = Page.find( params[:id] )
		authorize! :destroy, @page
		@page.destroy
    redirect_to pages_url
	end

end

