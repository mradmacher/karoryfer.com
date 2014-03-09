class AttachmentsController < ApplicationController
  layout :set_layout

  def index
  end

  def show
    attachment = current_album.attachments.find( params[:id] )
    redirect_to attachment.file.url
  end

  def new
    @attachment = Attachment.new
		authorize! :write_attachment, Attachment
  end

  def create
		@attachment = current_album.attachments.new( params[:attachment] )
		authorize! :write_attachment, @attachment
    if @attachment.save
      redirect_to artist_album_attachments_url( current_artist, current_album )
    else
      render :action => 'new'
    end
  end

  def destroy
		@attachment = current_album.attachments.find( params[:id] )
		authorize! :write_attachment, @attachment
		@attachment.destroy
    redirect_to artist_album_attachments_url( current_artist, current_album )
  end

  private
  def current_album
    current_artist.albums.find_by_reference( params[:album_id] )
  end

end

