# frozen_string_literal: true

require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../fixtures/attachments', __dir__)

  describe Attachment do
    it 'validates filename uniqueness for album' do
      existing_file = File.open(File.join(FIXTURES_DIR, 'att1.jpg'))
      existing = Attachment.sham! file: existing_file
      tested = Attachment.sham! album: existing.album, file: existing_file
      refute tested.valid?
      assert tested.errors[:file].include? I18n.t(
        'activerecord.errors.models.attachment.attributes.file.taken'
      )
    end

    it 'validates album presence' do
      attachment = Attachment.sham! :build
      attachment.album_id = nil
      refute attachment.valid?
      assert attachment.errors[:album_id].include? I18n.t(
        'activerecord.errors.models.attachment.attributes.album_id.blank'
      )
    end

    it 'validates file presence' do
      attachment = Attachment.sham! :build, file: nil

      refute attachment.valid?
      assert attachment.errors[:file].include? I18n.t(
        'activerecord.errors.models.attachment.attributes.file.blank'
      )
    end

    describe 'on save' do
      it 'places file in proper dir' do
        attachment = Attachment.sham! file: File.open(File.join(FIXTURES_DIR, 'att1.jpg'))
        assert File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att1.jpg')
      end

      it 'replaces old file with new' do
        attachment = Attachment.sham! file: File.open(File.join(FIXTURES_DIR, 'att1.jpg'))
        assert File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att1.jpg')

        attachment.file = File.open(File.join(FIXTURES_DIR, 'att2.pdf'))
        attachment.save
        refute File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att1.jpg')
        assert File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att2.pdf')
      end
    end

    describe 'on destroy' do
      it 'removes file from storage' do
        attachment = Attachment.sham! file: File.open(File.join(FIXTURES_DIR, 'att1.jpg'))
        assert File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att1.jpg')

        attachment.destroy
        refute File.exist? File.join(Rails.root, 'public', 'uploads', 'attachments', attachment.album.id.to_s, 'att1.jpg')
      end
    end
  end
end
