# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :album

  validates :album_id, presence: true
  validate :validate_file
  before_destroy :remove_file!

  class Uploader < CarrierWave::Uploader::Base
    def store_dir
      File.join(Rails.root, 'public', 'uploads', 'attachments', model.album.id.to_s)
    end
  end

  mount_uploader :file, Uploader

  private

  def validate_file
    errors.add(:file, I18n.t('activerecord.errors.models.attachment.attributes.file.blank')) if file.identifier.nil?
    return unless album_id

    similar = Attachment.where(album_id: album_id, file: file.identifier)
    similar = similar.where('id <> ?', id) if id

    errors.add(:file, I18n.t('activerecord.errors.models.attachment.attributes.file.taken')) if similar.exists?
  end
end
