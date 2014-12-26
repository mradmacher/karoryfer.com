class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def show
    redirect_to resource.show.file.url
  end

  private

  def redirect_create(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def redirect_destroy(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def view_class
    AttachmentView
  end

  def resource
    Resource::AttachmentResource.new(abilities, params, current_album)
  end
end
