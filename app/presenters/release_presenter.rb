# frozen_string_literal: true

class ReleasePresenter < Presenter
  def_delegators(:resource, :id, :album, :format, :external_url, :file_name, :url, :file?, :for_sale?, :digital?, :physical?, :external?)

  def title
    format
  end

  def price
    whole_price = discount ? discount.whole_price : resource.whole_price
    return nil if whole_price.nil?

    "#{whole_price / 100}.#{Kernel.format('%02d', whole_price % 100)}"
  end

  def currency
    discount ? discount.currency : resource.currency
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
    release_paypal_path(resource, did: discount&.reference_id)
  end

  def download_path
    download_artist_album_path(resource.album.artist, resource.album, resource.format, pid: purchase_reference_id) if resource.format != Release::CD
  end

  def path
    admin_artist_album_release_path(resource.album.artist, resource.album, resource)
  end

  def edit_path
    edit_admin_artist_album_release_path(resource.album.artist,
                                         resource.album,
                                         resource)
  end

  attr_accessor :purchase_reference_id, :discount

  def purchased?
    !purchase_reference_id.nil?
  end

  def can_be_removed?
    !for_sale? || physical? || downloads.zero?
  end
end
