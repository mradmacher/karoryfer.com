# frozen_string_literal: true

class Downloader
  class DownloadsExceededError < StandardError; end
  class NotPurchasedError < StandardError; end

  attr_reader :album

  def initialize(album)
    @album = album
  end

  def download(release_format:, remote_ip: nil, purchase_reference: nil)
    release = album.releases.in_format(release_format).first
    return nil if release.nil?

    purchase = Purchase.where(release_id: release.id, reference_id: purchase_reference).first if purchase_reference
    raise NotPurchasedError if release.for_sale? && !release.purchased?(purchase)

    raise DownloadsExceededError if purchase&.downloads_exceeded?

    if purchase&.presigned_url!
      DownloadEvent.create(remote_ip: remote_ip, release_id: release.id, purchase_id: purchase&.id, created_at: Time.now)
      purchase.presigned_url
    elsif release.external_url.present?
      DownloadEvent.create(remote_ip: remote_ip, release_id: release.id, purchase_id: purchase&.id, created_at: Time.now)
      release.external_url
    elsif release.file?
      DownloadEvent.create(remote_ip: remote_ip, release_id: release.id, purchase_id: purchase&.id, created_at: Time.now)
      release.file
    end
  end
end
