class TracksController < ApplicationController
  layout :set_layout
  before_filter :set_album

  def show
    track = @album.tracks.find( params[:id] )
    authorize! :read, track
    redirect_to track.file.url
  end

  def new
		authorize! :write, Track, @album
    @track = @album.tracks.new
  end

  def edit
		@track = @album.tracks.find( params[:id] )
		authorize! :write, @track
  end

  def create
		authorize! :write, Track, @album
		@track = @album.tracks.new( params[:track] )
    if @track.save
      redirect_to artist_album_url( current_artist, @album )
    else
      render :action => 'new'
    end
  end

	def update
		@track = @album.tracks.find( params[:id] )
    @track.assign_attributes( params[:track] )
    @track.album = @album
		authorize! :write, @track

		if @track.save
			redirect_to artist_album_url( current_artist, @album )
		else
			render :action => 'edit'
		end
	end

  def destroy
		@track = @album.tracks.find( params[:id] )
		authorize! :write, @track
		@track.destroy
    redirect_to artist_album_url( current_artist, @album )
  end

  private

  def set_album
    @album = current_artist.albums.find_by_reference( params[:album_id] )
  end
end


