# frozen_string_literal: true

class Purchase < ApplicationRecord
  MAX_DOWNLOADS = 20

  belongs_to :release
  has_many :download_events

  after_initialize :generate_reference_id

  def downloads_exceeded?
    download_events.count >= MAX_DOWNLOADS
  end

  def presigned_url!(signer = AwsPresigner.new)
    return presigned_url unless generate_presigned_url?

    if presigned_url.nil?
      update(
        presigned_url: signer.generate_url(release.external_url),
        presigned_url_generated_at: Time.now
      )
    end
    presigned_url.presence
  end

  private

  def generate_reference_id
    self.reference_id = SecureRandom.uuid if reference_id.nil?
  end
end
