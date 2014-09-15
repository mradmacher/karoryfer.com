class PagesController < CurrentArtistController
  layout :set_layout

  def show
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :read, @page
  end

  def edit
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :write, @page
  end

  def new
		authorize! :write, Page, current_artist
		@page = current_artist.pages.new
  end

	def update
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :write, @page
    @page.assign_attributes( params[:page] )
    @page.artist = current_artist

		if @page.save
			redirect_to artist_page_url( current_artist, @page )
		else
			render :action => "edit"
		end
	end

	def create
		authorize! :write, Page, current_artist
    @page = current_artist.pages.new( params[:page] )
		if @page.save
			redirect_to artist_page_url( current_artist, @page )
		else
			render :action => 'new'
		end
	end

	def destroy
		@page = current_artist.pages.find_by_reference( params[:id] )
		authorize! :write, @page
		@page.destroy
    redirect_to artist_url( current_artist )
	end
end

