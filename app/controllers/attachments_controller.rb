class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def show
    attachment = resource.show
    redirect_to attachment.file.url
  end

  def new
    @attachment = resource.new
  end

  def create
    resource.create
    redirect_to artist_album_url(current_artist, current_album)
  rescue Resource::InvalidResource => e
		@track = e.resource
    render :action => 'new'
  end

  def destroy
    resource.destroy
    redirect_to artist_album_url(current_artist, current_album)
  end

  private

  def resource
    Resource::AttachmentResource.new(abilities, params, current_album)
  end
end
