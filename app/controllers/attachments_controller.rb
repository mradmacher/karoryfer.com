class AttachmentsController < CurrentArtistController
  layout :set_layout
  before_filter :set_album

  def show
    attachment = @album.attachments.find( params[:id] )
    redirect_to attachment.file.url
  end

  def new
		authorize! :write, Attachment, @album
    @attachment = @album.attachments.new
  end

  def create
    authorize! :write, Attachment, @album
		@attachment = @album.attachments.new( params[:attachment] )
    @attachment.album = @album
    if @attachment.save
      redirect_to artist_album_url( current_artist, @album )
    else
      render :action => 'new'
    end
  end

  def destroy
		@attachment = @album.attachments.find( params[:id] )
		authorize! :write, @attachment
		@attachment.destroy
    redirect_to artist_album_url( current_artist, @album )
  end

  private

  def set_album
    @album = current_artist.albums.find_by_reference( params[:album_id] )
  end
end

