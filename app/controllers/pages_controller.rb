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
		authorize! :write_page, Page
		flash[:back] = request.referrer
		@page = Page.find( params[:id] )
  end

  def new
		@page = Page.new
		authorize! :write_page, @page
  end

	def update
		@page = Page.find( params[:id] )
		authorize! :write_page, @page

		if @page.update_attributes( params[:page] )
			redirect_to page_url( @page )
		else
			render :action => "edit"
		end
	end

	def create
		authorize! :write_page, Page
		@page = Page.new( params[:page] )
		if @page.save
			redirect_to page_url( @page )
		else
			render :action => 'new'
		end
	end

	def destroy
		@page = Page.find( params[:id] )
		authorize! :write_page, @page
		@page.destroy
    redirect_to pages_url
	end
end

