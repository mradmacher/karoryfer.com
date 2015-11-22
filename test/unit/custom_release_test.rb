require 'test_helper'

class CustomReleaseTest < ActiveSupport::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    Uploader::Release.store_dir = File.join(@tmp_dir, 'albums')

    @artist = Artist.sham! name: 'Jęczące Brzękodźwięki',
      reference: 'jeczace-brzekodzwieki'
    @album = Album.sham! title: 'Największe przeboje', artist: @artist,
      reference: 'najwieksze-przeboje'
    @file_path = File.join(FIXTURES_DIR, 'release.zip')
  end

  def teardown
    FileUtils.remove_entry_secure @tmp_dir
  end

  def test_stores_album_release_without_suffix_if_same_as_extension
    release = Release.new(format: Release::ZIP, album: @album)
    release.file = File.open(@file_path)
    release.save

    release_file_path = File.join(@tmp_dir, 'albums', 'jeczace-brzekodzwieki',
      'jeczace-brzekodzwieki-najwieksze-przeboje.zip')
    assert_equal release_file_path, release.file.path
    assert File.exists? release_file_path
  end

  def test_on_delete_removes_release
    release = Release.create(format: Release::ZIP, album: @album,
      file: File.open(@file_path))
    release_file_path = release.file.path
    assert File.exists? release_file_path
    release.destroy
    refute File.exists? release_file_path
  end
end
