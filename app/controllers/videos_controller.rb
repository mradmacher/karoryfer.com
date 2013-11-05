class VideosController < ApplicationController
	before_filter :require_user, :except => [:index, :show]
  layout :set_layout

  def index
    @videos = current_artist?? current_artist.videos : Video.all
  end

  def show
		@video = Video.find( params[:id] )
    redirect_to( artist_video_url( @video.artist, @video ), :status => 301 ) unless current_artist?
		authorize!( :read, @video )
  end

  def new
		@video = Video.new
		@video.artist = current_artist if current_artist?
		authorize! :create, @video
  end

  def edit
		@video = Video.find( params[:id] )
    redirect_to( edit_artist_video_url( @video.artist, @video ), :status => 301 ) unless current_artist?
		authorize! :update, @video
  end

	def create
		@video = Video.new( params[:video] )
		authorize! :create, @video
		if @video.save
			redirect_to artist_video_url( @video.artist, @video )
		else
			render :action => 'new'
		end
	end

	def update
		@video = Video.find( params[:id] )
		authorize! :update, @video
		if @video.update_attributes( params[:video] )
			redirect_to artist_video_url( @video.artist, @video )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@video = Video.find( params[:id] )
		authorize! :destroy, @video
		@video.destroy
    redirect_to artist_videos_url( @video.artist )
	end

  private
  def set_layout
    current_artist?? 'current_artist' : 'application'
  end

end

