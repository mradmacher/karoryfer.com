require 'test_helper'

class CustomReleaseTest < ActiveSupport::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::Release.album_store_dir = File.join( @tmp_dir, 'albums' )
    Uploader::Release.track_store_dir = File.join( @tmp_dir, 'tracks' )

    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki',
      reference: 'jeczace-brzekodzwieki'
    @album = Album.sham! title: 'Największe przeboje', artist: @artist,
      reference: 'najwieksze-przeboje'
    @track = Track.sham! album: @album
    @file_path = File.join( FIXTURES_DIR, 'attachments', 'att2.pdf' )
    @other_file_path = File.join( FIXTURES_DIR, 'attachments', 'att1.jpg' )
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_stores_album_release_without_suffix_if_same_as_extension
    release = Release.new( format: 'pdf', album: @album, generated: false )
    release.file = File.open( @file_path )
    release.save

    release_file_path = File.join( @tmp_dir, 'albums', 'jeczace-brzekodzwieki',
      'jeczace-brzekodzwieki-najwieksze-przeboje.pdf' )
    assert_equal release_file_path, release.file.path
    assert File.exists? release_file_path
  end

  def test_stores_album_release_with_suffix
    release = Release.new( format: 'img', album: @album, generated: false )
    release.file = File.open( @other_file_path )
    release.save

    release_file_path = File.join( @tmp_dir, 'albums', 'jeczace-brzekodzwieki',
      'jeczace-brzekodzwieki-najwieksze-przeboje-img.jpg' )
    assert_equal release_file_path, release.file.path
    assert File.exists? release_file_path
  end

  def test_stores_track_release_file
    release = Release.new( format: 'pdf', track: @track, generated: false )
    release.file = File.open( @file_path )
    release.save

    release_file_path = File.join( @tmp_dir, 'tracks', (@track.id/1000).to_s, "#{@track.id}.pdf" )
    assert_equal release_file_path, release.file.path
    assert File.exists? release_file_path
  end

  def test_on_delete_removes_album_release
    release = Release.create( format: 'pdf', album: @album,
      generated: false, file: File.open( @file_path ) )
    release_file_path = release.file.path
    assert File.exists? release_file_path
    release.destroy
    refute File.exists? release_file_path
  end

  def test_on_delete_removes_track_release
    release = Release.create( format: 'pdf', track: @track,
      generated: false, file: File.open( @file_path ) )
    release_file_path = release.file.path
    assert File.exists? release_file_path
    release.destroy
    refute File.exists? release_file_path
  end
end

