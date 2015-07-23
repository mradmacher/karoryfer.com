class ReleasePresenter < Presenter
  def_delegators(:resource, :album, :format, :file?)

  def available_files
    Settings.filer.list('*.zip')
  end

  def _path
    artist_album_release_path(resource.album.artist, resource.album, resource)
  end

  def _edit_path
    edit_artist_album_release_path(resource.album.artist, resource.album, resource)
  end
end
