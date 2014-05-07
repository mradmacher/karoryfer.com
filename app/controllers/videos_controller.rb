class VideosController < ApplicationController
  layout :set_layout

  def index
    @videos = current_artist.videos
  end

  def show
		@video = current_artist.videos.find( params[:id] )
		authorize! :read, @video
  end

  def new
		authorize! :write, Video, current_artist
		@video = current_artist.videos.new
  end

  def edit
		@video = current_artist.videos.find( params[:id] )
		authorize! :write, @video
  end

	def create
		authorize! :write, Video, current_artist
		@video = current_artist.videos.new( params[:video] )
		if @video.save
			redirect_to artist_video_url( @video.artist, @video )
		else
			render :action => 'new'
		end
	end

	def update
		@video = current_artist.videos.find( params[:id] )
    @video.assign_attributes( params[:video] )
    @video.artist = current_artist
		authorize! :write, @video

		if @video.save
			redirect_to artist_video_url( @video.artist, @video )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@video = current_artist.videos.find( params[:id] )
		authorize! :write, @video
		@video.destroy
    redirect_to artist_videos_url( @video.artist )
	end
end

