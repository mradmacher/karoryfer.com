class TrackPresenter < Presenter
  def_delegators(:resource, :title)

  def available_files
    Settings.filer.list('*.wav')
  end

  def _path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end

  def _edit_path
    artist_album_track_path(resource.album.artist, resource.album, resource)
  end
end
