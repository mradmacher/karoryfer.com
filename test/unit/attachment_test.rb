require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures/attachments', __FILE__)

  def test_validates_filename_uniqueness_for_album
    existing_file = File.open( File.join( FIXTURES_DIR, 'att1.jpg' ) )
    existing = Attachment.sham! file: existing_file
    tested = Attachment.sham! album: existing.album, file: existing_file
    refute tested.valid?
		assert tested.errors[:file].include? I18n.t(
      'activerecord.errors.models.attachment.attributes.file.taken' )
  end

  def test_validates_album_presence
    attachment = Attachment.sham! :build
    attachment.album_id = nil
    refute attachment.valid?
		assert attachment.errors[:album_id].include? I18n.t(
      'activerecord.errors.models.attachment.attributes.album_id.blank' )
  end

  def test_validates_file_presence
    attachment = Attachment.sham! :build, file: nil

    refute attachment.valid?
    assert attachment.errors[:file].include? I18n.t(
      'activerecord.errors.models.attachment.attributes.file.blank' )
  end

  def test_on_save_places_file_in_proper_dir
    attachment = Attachment.sham! file: File.open( File.join( FIXTURES_DIR, 'att1.jpg' ) )
    assert File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att1.jpg' )
  end

  def test_on_save_replaces_old_file_with_new_one
    attachment = Attachment.sham! file: File.open( File.join( FIXTURES_DIR, 'att1.jpg' ) )
    assert File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att1.jpg' )

    attachment.file = File.open( File.join( FIXTURES_DIR, 'att2.pdf' ) )
    attachment.save
    refute File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att1.jpg' )
    assert File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att2.pdf' )
  end

  def test_on_destroy_removes_file_from_storage
    attachment = Attachment.sham! file: File.open( File.join( FIXTURES_DIR, 'att1.jpg' ) )
    assert File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att1.jpg' )

    attachment.destroy
    refute File.exists? File.join( Attachment::Uploader.store_dir, attachment.album.id.to_s, 'att1.jpg' )
  end
end

