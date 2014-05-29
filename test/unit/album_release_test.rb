#encoding: utf-8
require 'test_helper'
require 'release_helper'

class AlbumReleaseTest < ActiveSupport::TestCase
  include ReleaseHelper

  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::Release.album_store_dir = File.join( @tmp_dir, 'storage' )

    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki'
    @album = Album.sham! title: 'Tłuczące pokrowce jeżozwierza',
      image: File.open( File.join( FIXTURES_DIR, 'okladka.jpg' ) )
    3.times do |i|
      Track.sham! album: @album,
        file: File.open( File.join( FIXTURES_DIR, 'tracks', "#{i+1}.wav" ) )
    end
    @album.tracks.each do |track|
      puts track.file
    end

    @album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att1.jpg' ) ) )
    @album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att2.pdf' ) ) )
    @album.attachments.create( file: File.open( File.join( FIXTURES_DIR, 'attachments', 'att3.txt' ) ) )
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_on_create_makes_ogg_release
    release = @album.releases.create( format: Release::OGG )
    check_album_release release
  end

  def test_on_create_makes_flac_release
    release = @album.releases.create( format: Release::FLAC )
    check_album_release release
  end

  def test_on_create_makes_mp3_release
    release = @album.releases.create( format: Release::MP3 )
    check_album_release release
  end

  def test_on_delete_removes_files_from_storage
    ogg_release = @album.releases.create( format: Release::OGG )
    flac_release = @album.releases.create( format: Release::FLAC )

    ogg_artist_reference = ogg_release.album.artist.reference
    ogg_album_reference = ogg_release.album.reference
    ogg_archive_file_path = File.join( Uploader::Release.album_store_dir, ogg_artist_reference,
      "#{ogg_artist_reference}-#{ogg_album_reference}-#{ogg_release.format}.zip" )

    flac_artist_reference = flac_release.album.artist.reference
    flac_album_reference = flac_release.album.reference
    flac_archive_file_path = File.join( Uploader::Release.album_store_dir, flac_artist_reference,
      "#{flac_artist_reference}-#{flac_album_reference}-#{flac_release.format}.zip" )

    assert File.exists? ogg_archive_file_path
    assert File.exists? flac_archive_file_path

    ogg_release.destroy
    refute File.exists? ogg_archive_file_path
    assert File.exists? flac_archive_file_path
  end
end

