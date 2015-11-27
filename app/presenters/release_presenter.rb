class ReleasePresenter < Presenter
  def_delegators(:resource, :album, :format, :file?)

  def available_files
    Settings.filer.list('*.zip')
  end

  def path
    artist_album_release_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    edit_artist_album_release_path(resource.album.artist,
                                   resource.album,
                                   resource)
  end

  def can_be_updated?
    abilities.allow?(:write_release, resource.album)
  end

  def can_be_deleted?
    can_be_updated?
  end
end
