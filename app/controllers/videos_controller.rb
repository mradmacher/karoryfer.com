class VideosController < ApplicationController
	before_filter :require_user, :except => [:index, :show]
  layout :set_layout

  def index
    @videos = current_artist?? current_artist.videos : Video.all
  end

  def show
		@video = current_artist.videos.find( params[:id] )
		authorize! :read_video, @video
  end

  def new
		@video = Video.new
		@video.artist = current_artist
		authorize! :write_video, @video
  end

  def edit
		@video = current_artist.videos.find( params[:id] )
		authorize! :write_video, @video
  end

	def create
		@video = current_artist.videos.new( params[:video] )
		authorize! :write_video, @video
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
		authorize! :write_video, @video

		if @video.save
			redirect_to artist_video_url( @video.artist, @video )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@video = current_artist.videos.find( params[:id] )
		authorize! :write_video, @video
		@video.destroy
    redirect_to artist_videos_url( @video.artist )
	end
end

