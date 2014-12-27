class AttachmentsController < CurrentAlbumController
  layout :set_layout

  def show
    redirect_to cruder.show.file.url
  end

  private

  def redirect_create(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def redirect_destroy(obj)
    redirect_to artist_album_url(current_artist, current_album)
  end

  def presenter_class
    AttachmentPresenter
  end

  def cruder
    AttachmentCruder.new(abilities, params, current_album)
  end
end
