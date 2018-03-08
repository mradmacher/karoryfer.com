# frozen_string_literal: true

class ReleasePresenter < Presenter
  def_delegators(:resource, :album, :downloads, :format, :url, :file?)

  def available_files
    Settings.filer.list('*.zip')
  end

  def download_path
    download_artist_album_path(resource.album.artist, resource.album, resource.format)
  end

  def path
    artist_album_release_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    edit_artist_album_release_path(resource.album.artist,
                                   resource.album,
                                   resource)
  end
end
