#encoding: utf-8
require 'test_helper'
require 'release_helper'

class TrackReleaseTest < ActiveSupport::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)
  include ReleaseHelper

  def setup
    @tmp_dir = Dir.mktmpdir
    Release::Uploader.track_store_dir = File.join( @tmp_dir, 'storage' )
    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki'
    @track = Track.sham! file: File.open( File.join( FIXTURES_DIR, 'tracks', "1.wav" ) )
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_on_create_makes_ogg_release
    release = @track.releases.create( format: Release::OGG )
    check_track_release release
  end

  def test_on_create_makes_mp3_release
    release = @track.releases.create( format: Release::MP3 )
    check_track_release release
  end

  def test_on_destroy_removes_file_from_storage
    other_track = Track.sham!
    ogg_release = @track.releases.create( format: Release::OGG )
    flac_release = @track.releases.create( format: Release::FLAC )
    partition = (@track.id / 1000).to_s

    assert File.exists?( File.join( Release::Uploader.track_store_dir, partition, "#{@track.id}.ogg" ) )
    assert File.exists?( File.join( Release::Uploader.track_store_dir, partition,  "#{@track.id}.flac" ) )

    ogg_release.destroy
    refute File.exists?( File.join( Release::Uploader.track_store_dir, partition, "#{@track.id}.ogg" ) )
    assert File.exists?( File.join( Release::Uploader.track_store_dir, partition, "#{@track.id}.flac" ) )
  end
end

