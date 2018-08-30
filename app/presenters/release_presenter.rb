# frozen_string_literal: true

class ReleasePresenter < Presenter
  def_delegators(:resource, :id, :album, :format, :url, :file?, :for_sale?, :currency, :digital?, :physical?)

  def title
    format
  end

  def price
    return nil if resource.whole_price.nil?
    "#{resource.whole_price/100}.#{Kernel.format('%02d', resource.whole_price%100)}"
  end

  def available_files
    Settings.filer.list('*.zip')
  end

  def downloads
    @downloads ||= if resource.for_sale?
      Purchase.where(release_id: resource.id).count
    else
      resource.downloads
    end
  end

  def paypal_url
    release_paypal_path(resource)
  end

  def download_path
    if resource.format != Release::CD
      download_artist_album_path(resource.album.artist, resource.album, resource.format, pid: purchase_reference_id)
    end
  end

  def path
    artist_album_release_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    edit_artist_album_release_path(resource.album.artist,
                                   resource.album,
                                   resource)
  end

  attr_accessor :purchase_reference_id

  def purchased?
    !purchase_reference_id.nil?
  end

  def can_be_removed?
    !for_sale? || physical? || downloads == 0
  end
end
