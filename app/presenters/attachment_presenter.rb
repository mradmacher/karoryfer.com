class AttachmentPresenter < Presenter
  def_delegators(:resource, :file, :file?)

  def path
    artist_album_attachment_path(resource.album.artist, resource.album, resource)
  end

  def can_be_updated?
    abilities.allow?(:write_attachment, resource.album)
  end

  def can_be_deleted?
    can_be_updated?
  end
end
