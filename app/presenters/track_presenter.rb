class TrackPresenter < Presenter
  def_delegators(:resource, :title, :file, :file?)

  def available_files
    Settings.filer.list('*.wav')
  end

  def path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end
end
