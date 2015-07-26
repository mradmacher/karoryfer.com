class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = cruder.new
    super
  end

  def show
    redirect_to cruder.show.file.url
  end

  private

  def create_redirect_path(obj)
    artist_album_attachments_url(current_artist, current_album)
  end

  def destroy_redirect_path(obj)
    artist_album_attachments_url(current_artist, current_album)
  end

  def cruder
    AttachmentCruder.new(abilities, params, current_album)
  end
end
