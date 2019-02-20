# frozen_string_literal: true

class Purchase < ApplicationRecord
  MAX_DOWNLOADS = 7

  belongs_to :release

  after_initialize :generate_reference_id

  def downloads_exceeded?
    downloads >= MAX_DOWNLOADS
  end

  private

  def generate_reference_id
    self.reference_id = SecureRandom.hex if reference_id.nil?
  end
end
