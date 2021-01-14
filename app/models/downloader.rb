# frozen_string_literal: true

class Downloader
  class DownloadsExceededError < StandardError; end
  class NotPurchasedError < StandardError; end

  attr_reader :album, :remote_ip

  def initialize(album, remote_ip: nil)
    @album = album
    @remote_ip = remote_ip
  end

  def free_download(release_format)
    release = album.releases.in_format(release_format).first
    return nil if release.nil?

    raise NotPurchasedError if release.for_sale?

    downloadable(release, nil)
  end

  def purchased_download(purchase_reference)
    purchase = Purchase.joins(:release).where('releases.album_id' => album.id).where(reference_id: purchase_reference).first

    raise NotPurchasedError if purchase.nil?

    raise DownloadsExceededError if purchase.downloads_exceeded?

    downloadable(purchase.release, purchase)
  end

  private

  def downloadable(release, purchase)
    if purchase&.presigned_url!
      create_download_event(release.id, purchase.id, purchase.presigned_url)
      purchase.presigned_url
    elsif release.external_url.present?
      create_download_event(release.id, purchase&.id, release.external_url)
      release.external_url
    elsif release.file?
      create_download_event(release.id, purchase&.id, release.attributes['file'])
      release.file
    end
  end

  def create_download_event(release_id, purchase_id, source)
    DownloadEvent.create(remote_ip: remote_ip, release_id: release_id, purchase_id: purchase_id, created_at: Time.now, source: source)
  end
end
