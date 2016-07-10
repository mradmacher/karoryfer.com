class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def index
    @presenter = decorate(cruder.new)
    super
  end

  def show
    redirect_to cruder.show.file.url
  end

  private

  def create_redirect_path(_)
    artist_album_attachments_url(current_artist, current_album)
  end

  def destroy_redirect_path(_)
    artist_album_attachments_url(current_artist, current_album)
  end

  def cruder
    AttachmentCruder.new(params, policy, current_album)
  end
end
