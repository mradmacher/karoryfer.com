class PostsController < ApplicationController
	before_filter :require_user, :except => [:index, :show]
  layout :set_layout

  def index
    @selected_year = "#{params[:year]}"
    @posts = current_artist?? current_artist.posts.published : Post.published
    @posts = @posts.created_in_year( params[:year] ) if params[:year]
    render :index
  end

  def drafts
		raise User::AccessDenied unless current_user?
    @category = :drafts
    @posts = current_user.unpublished_posts
    render :index
  end

  def show
		@post = current_artist.posts.find( params[:id] )
		authorize! :read_post, @post
  end

  def new
		@post = Post.new
		@post.artist = current_artist
		authorize! :write_post, @post
  end

  def edit
		@post = current_artist.posts.find( params[:id] )
		authorize! :write_post, @post
  end

	def create
		@post = current_artist.posts.new( params[:post] )
		authorize! :write_post, @post
		if @post.save
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'new'
		end
	end

	def update
		@post = current_artist.posts.find( params[:id] )
    @post.assign_attributes( params[:post] )
    @post.artist = current_artist
		authorize! :write_post, @post

		if @post.save
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@post = current_artist.posts.find( params[:id] )
		authorize! :write_post, @post
		@post.destroy
    redirect_to artist_posts_url( @post.artist )
	end
end

