class PagesController < ApplicationController
	before_filter :require_user, :except => [:index, :show]
  layout :set_layout

  def show
		@page = current_artist.pages.find_by_reference( params[:id] )
  end

  def edit
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :write_page, @page
  end

  def new
		@page = Page.new
    @page.artist = current_artist
		authorize! :write_page, @page
  end

	def update
		@page = current_artist.pages.find_by_reference( params[:id] )
    @page.assign_attributes( params[:page] )
    @page.artist = current_artist
		authorize! :write_page, @page

		if @page.save
			redirect_to artist_page_url( current_artist, @page )
		else
			render :action => "edit"
		end
	end

	def create
    @page = current_artist.pages.new( params[:page] )
		authorize! :write_page, @page
		if @page.save
			redirect_to artist_page_url( current_artist, @page )
		else
			render :action => 'new'
		end
	end

	def destroy
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :write_page, @page
		@page.destroy
    redirect_to artist_url( current_artist )
	end
end

