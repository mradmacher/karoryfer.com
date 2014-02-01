class AlbumsController < ApplicationController
	before_filter :require_user, :except => [:index, :show, :release, :download]
  layout :set_layout

  def index
		@albums = current_artist ? current_artist.albums.published.all : Album.published.all
  end

  def show
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :read_album, @album
  end

  def edit
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write_album, @album
  end

  def new
		@album = Album.new
		@album.artist = current_artist
		authorize! :write_album, Album
  end

	def create
		@album = current_artist.albums.new( params[:album] )
		authorize! :write_album, @album
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'new'
		end
	end

	def update
		@album = current_artist.albums.find_by_reference( params[:id] )
		@album.assign_attributes( params[:album] )
    @album.artist = current_artist
		authorize! :write_album, @album
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write_album, @album
		@album.destroy
		redirect_to artist_albums_url( current_artist )
	end

  def release
    @artist = Artist.find( params[:artist_id] )
		@album = @artist.albums.find_by_reference( params[:id] )
    release = @album.releases.in_format( params[:format] ).first
    #TODO release.touch
    #FIXME
    # release = @album.releases.build( format: params[:format] )
    # release.valid?
    # argv = "karoryfer_releaser_#{@album.id}_#{release.format}"
    argv = "release-#{@artist.id}-#{@album.id}-#{params[:format]}"
    if release.nil?
      unless `ps aux`.include? argv
        Spawnling.new( argv: argv ) do
          @album.releases.create( format: params[:format] )
        end
      end
    end
    if request.xhr?
      render json: { success: true }
    else
      redirect_to album_url(@album)
    end
  end

  def download
    @artist = Artist.find( params[:artist_id] )
		@album = @artist.albums.find_by_reference( params[:id] )
    release = @album.releases.in_format( params[:format] ).first
    if release.nil?
      if request.xhr?
        render json: { success: false }
      else
        redirect_to album_url(@album)
      end
    else
      if request.xhr?
        render json: { success: true, url: release.file.url }
      else
        redirect_to release.file.url
      end
    end
  end
end

