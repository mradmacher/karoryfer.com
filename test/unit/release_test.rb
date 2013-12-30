require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  def test_validates_album_or_track_presence
    track = Track.sham!
    release = Release.sham! :build,
      track: nil,
      album: nil
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

  def test_validates_all_album_tracks_file_presence_for_album_release
    skip 'to consider'
=begin
    album = Album.sham!
    Track.sham! album: album, file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    track = Track.sham! album: album, file: nil
    release = album.releases.build( format: 'flac' )
    refute release.valid?
		assert release.errors[:base].include? I18n.t(
      'activerecord.errors.models.release.album_or_track.missing_files' )

    track.file = File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    track.save
    release = album.releases.build( format: 'flac' )
    assert release.valid?
=end
  end

  def test_validates_track_file_presence_for_track_release
    skip 'to consider'
=begin
    track = Track.sham! file: nil
    release = track.releases.build( format: 'flac' )
    refute release.valid?
		assert release.errors[:base].include? I18n.t(
      'activerecord.errors.models.release.album_or_track.missing_files' )

    track.file = File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    track.save
    release = track.releases.build( format: 'flac' )
    assert release.valid?
=end
  end


  def test_validates_if_not_both_for_album_and_track
    track = Track.sham!
    release = Release.sham! :build,
      track: track,
      album: track.album
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
    ['ogg', 'flac', 'mp3'].each do |format|
      release.format = format
      assert release.valid?
    end
    ['ggo', 'calf', '3pm'].each do |format|
      release.format = format
      refute release.valid?
      assert release.errors[:format].include? I18n.t(
        'activerecord.errors.models.release.attributes.format.inclusion' )
    end
  end

  def test_release_url_for_album_is_proper
    release = Release.sham! :build, :album
    assert_equal "#{release.publisher_url}/#{release.album.artist.reference}/wydawnictwa/#{release.album.reference}",
      release.release_url
  end

  def test_release_url_for_track_is_proper
    release = Release.sham! :build, :track
    assert_equal "#{release.publisher_url}/#{release.track.artist.reference}/wydawnictwa/#{release.track.album.reference}",
      release.release_url
  end

  def test_has_set_defaults
    assert_equal 6, AlbumReleaser.new( @album, 'ogg' ).ogg_quality
    assert_equal 3, TrackReleaser.new( @track, 'ogg' ).ogg_quality
    assert_equal 1, AlbumReleaser.new( @album, 'mp3' ).mp3_quality
    assert_equal 6, TrackReleaser.new( @track, 'mp3' ).mp3_quality
  end
end

