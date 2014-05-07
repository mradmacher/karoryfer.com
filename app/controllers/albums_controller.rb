class AlbumsController < ApplicationController
  layout :set_layout

  def index
		@albums = current_artist.albums.published.all
  end

  def show
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :read, @album
  end

  def edit
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
  end

  def new
		authorize! :write, Album, current_artist
		@album = current_artist.albums.new
  end

	def create
		authorize! :write, Album, current_artist
		@album = current_artist.albums.new( params[:album] )
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'new'
		end
	end

	def update
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
		@album.assign_attributes( params[:album] )
    @album.artist = current_artist
		if @album.save
			redirect_to artist_album_url( @album.artist, @album )
		else
			render :action => 'edit'
		end
	end

	def destroy
		@album = current_artist.albums.find_by_reference( params[:id] )
		authorize! :write, @album
		@album.destroy
		redirect_to artist_albums_url( current_artist )
	end

  def release
		@album = current_artist.albums.find_by_reference( params[:id] )
    release = @album.releases.in_format( params[:format] ).first
    release_exists = !release.nil?
    if release_exists
      release.touch
    else
      release = @album.releases.build( format: params[:format] )
      if release.valid?
        argv = "release-#{current_artist.id}-#{@album.id}-#{release.format}"
        unless `ps aux`.include? argv
          Spawnling.new( argv: argv ) do
            release.save
          end
        end
      end
    end
    if request.xhr?
      render json: { success: true }
    else
      if release_exists
        redirect_to release.file.url
      else
        redirect_to artist_album_url(current_artist, @album), notice: I18n.t('label.release_message')
      end
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
        redirect_to artist_album_url(@artist, @album)
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

