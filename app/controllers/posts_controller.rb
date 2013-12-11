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
		raise User::AccessDenied unless current_user.admin?
    @category = :drafts
    @posts = current_user.unpublished_posts
    render :index
  end

  def show
		@post = Post.find( params[:id] )
    redirect_to( artist_post_url( @post.artist, @post ), :status => 301 ) unless current_artist?
		authorize!( :read_post, @post )
  end

  def new
		@post = Post.new
		@post.artist = current_artist if current_artist?
		authorize! :write_post, @post
  end

  def edit
		@post = Post.find( params[:id] )
    redirect_to( edit_artist_post_url( @post.artist, @post ), :status => 301 ) unless current_artist?
		authorize! :write_post, @post
  end

	def create
		@post = Post.new( params[:post] )
		authorize! :write_post, @post
		if @post.save
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'new'
		end
	end

	def update
		@post = Post.find( params[:id] )
		authorize! :write_post, @post
		if @post.update_attributes( params[:post] )
			redirect_to artist_post_url( @post.artist, @post )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@post = Post.find( params[:id] )
		authorize! :write_post, @post
		@post.destroy
    redirect_to artist_posts_url( @post.artist )
	end

  private
  def set_layout
    current_artist?? 'current_artist' : 'application'
  end

end
