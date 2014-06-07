#encoding: utf-8
require 'test_helper'
require 'release_helper'

class TrackReleaseTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)
  include ReleaseHelper

  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::Release.track_store_dir = @tmp_dir
    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki'
    @track = Track.sham! file: File.open( File.join( FIXTURES_DIR, 'tracks', "1.wav" ) )
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_creates_ogg_release
    release = Release.create( owner: @track, format: Release::OGG )
    release.generate!
    check_track_release release
  end

  def test_creates_mp3_release
    release = Release.create( owner: @track, format: Release::MP3 )
    release.generate!
    check_track_release release
  end

  def expected_release_url( track )
    "#{Publisher.instance.url}/#{track.artist.reference}/wydawnictwa/#{track.album.reference}"
  end

  def check_track_release( release )
    track = release.owner
    file_path = release.file.path

    assert File.exists? file_path
    assert_equal "#{track.id}.#{release.format}", File.basename( file_path )
    type = case release.format
      when Release::OGG then 'Ogg'
      when Release::MP3 then 'MPEG'
      when Release::FLAC then 'FLAC'
    end
    assert `file #{file_path}` =~ /#{type}/

    assert_tags file_path, track, Publisher.instance, expected_release_url( track )

    (Release::FORMATS - [release.format]).each do |format|
      assert Dir.glob( File.join( File.dirname( file_path ), "*.#{format}" ) ).empty?
    end
  end
end

