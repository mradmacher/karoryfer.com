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

  def test_validates_format_inclusion_if_generated
    release = Release.sham! :build
    release.generated = true
    ['oga', 'mp', 'floc'].each do |format|
      release.format = format
      refute release.valid?
      assert release.errors[:format].include? I18n.t(
        'activerecord.errors.models.release.attributes.format.inclusion' )
    end

    ['ogg', 'mp3', 'flac'].each do |format|
      release.format = format
      assert release.valid?
    end

    release.generated = false
    ['oga', 'mp5', 'floc'].each do |format|
      release.format = format
      assert release.valid?
    end
  end

  def test_is_generated_by_default
    release = Release.new
    assert release.generated?
  end

  def test_requires_file_unless_generated
    release = Release.sham! :build
    release.remove_file!
    release.generated = true
    assert release.valid?
    release.generated = false
    refute release.valid?
  end
end

