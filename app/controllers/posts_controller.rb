class PostsController < ApplicationController
  layout :set_layout

  def index
    @posts = current_artist.posts
  end

  def show
		@post = current_artist.posts.find( params[:id] )
		authorize! :read, @post
  end

  def new
		authorize! :write, Post, current_artist
		@post = current_artist.posts.new
  end

  def edit
		@post = current_artist.posts.find( params[:id] )
		authorize! :write, @post
  end

	def create
		authorize! :write, Post, current_artist
		@post = current_artist.posts.new( params[:post] )
		if @post.save
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'new'
		end
	end

	def update
		@post = current_artist.posts.find( params[:id] )
		authorize! :write, @post
    @post.assign_attributes( params[:post] )
    @post.artist = current_artist

		if @post.save
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@post = current_artist.posts.find( params[:id] )
		authorize! :write, @post
		@post.destroy
    redirect_to artist_posts_url( @post.artist )
	end
end

