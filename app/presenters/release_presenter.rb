# frozen_string_literal: true

class ReleasePresenter < Presenter
  def_delegators(:resource, :id, :album, :format, :url, :file?, :price, :currency)

  def available_files
    Settings.filer.list('*.zip')
  end

  def downloads
    if resource.format == Release::CD
      Purchase.where(release_id: resource.id).count
    else
      resource.downloads
    end
  end

  def paypal_url
    release_paypal_path(resource)
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
