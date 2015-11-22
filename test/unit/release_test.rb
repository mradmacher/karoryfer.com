require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  def test_validates_album_presence
    release = Release.sham! :build
    release.album = nil
    refute release.valid?
    assert release.errors[:album_id].include? I18n.t(
      'activerecord.errors.models.release.attributes.album_id.blank' )

    release.album = Album.sham!
    assert release.valid?
  end

  def test_validates_format_presence
    release = Release.sham! :build
    [nil, ''].each do |format|
      release.format = format
      refute release.valid?
      assert release.errors[:format].include? I18n.t(
        'activerecord.errors.models.release.attributes.format.blank' )
    end
  end

  def test_validates_format_inclusion
    release = Release.sham! :build
    ['oga', 'mp', 'floc'].each do |format|
      release.format = format
      refute release.valid?
      assert release.errors[:format].include? I18n.t(
        'activerecord.errors.models.release.attributes.format.inclusion' )
    end

    Release::FORMATS.each do |format|
      release.format = format
      assert release.valid?
    end
  end

  def test_requires_file_unless_generated
    release = Release.sham! :build
    release.remove_file!
    [Release::MP3, Release::OGG, Release::FLAC].each do |format|
      release.format = format
      assert release.valid?
    end
    release.format = Release::ZIP
    refute release.valid?
  end
end
