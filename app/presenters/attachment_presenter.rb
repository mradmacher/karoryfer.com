class AttachmentPresenter < Presenter
  def_delegators(:resource, :file, :file?)

  def path
    artist_album_attachment_path(resource.album.artist, resource.album, resource)
  end
end
