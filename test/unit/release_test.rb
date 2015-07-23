require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  def test_validates_album_or_track_presence
    track = Track.sham!
    release = Release.sham! :build
    release.track = nil
    release.album = nil
    refute release.valid?
    assert release.errors[:base].include? I18n.t(
      'activerecord.errors.models.release.album_or_track.none' )

    release.album = nil
    release.track = track
    assert release.valid?

    release.track = nil
    release.album = track.album
    assert release.valid?
  end

  def test_validates_if_not_both_for_album_and_track
    track = Track.sham!
    release = Release.sham! :build
    release.track = track
    release.album = track.album
    refute release.valid?
    assert release.errors[:base].include? I18n.t(
      'activerecord.errors.models.release.album_or_track.both' )
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
