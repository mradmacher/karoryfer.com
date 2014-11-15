require 'test_helper'
require_relative 'albums_controller_tests/get_index'
require_relative 'albums_controller_tests/get_show'
require_relative 'albums_controller_tests/get_edit'
require_relative 'albums_controller_tests/get_new'
require_relative 'albums_controller_tests/put_update'
require_relative 'albums_controller_tests/post_create'
require_relative 'albums_controller_tests/delete_destroy'

class Release
  def generate_in_background!
    self.generated = false
    self.file = File.open( File.join( FIXTURES_DIR, 'attachments', 'att2.pdf' ) )
    self.save
  end
end

class AlbumsControllerTest < ActionController::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  include AlbumsControllerTests::GetIndex
  include AlbumsControllerTests::GetShow
  include AlbumsControllerTests::GetEdit
  include AlbumsControllerTests::GetNew
  include AlbumsControllerTests::PutUpdate
  include AlbumsControllerTests::PostCreate
  include AlbumsControllerTests::DeleteDestroy

  def test_get_download_redirects_to_album_if_release_without_file_in_provided_format
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac', generated: true )
    release.remove_file!
    refute release.file?
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to artist_album_url( album.artist, album )
  end

  def test_xhr_get_download_returns_false_if_release_without_file_in_provided_format
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac', generated: true )
    release.remove_file!
    refute release.file?
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal false, result['success']
  end

  def test_get_download_redirects_to_release_url_if_release_in_provided_format_exists
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac' )
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to release.file.url
  end

  def test_xhr_get_download_returns_release_url_if_release_in_provided_format_exists
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac' )
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_response :success

    result = JSON.parse(response.body)
    assert_equal true, result['success']
    assert_equal release.file.url, result['url']
  end

  def test_get_download_generates_release_for_release_without_file
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album
    release = Release.sham!( :generated, owner: album, format: 'flac' )

    refute release.file?
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert release.file?
  end

  def test_get_download_does_not_generate_release_if_file_exists
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac' )

    was_updated_at = release.updated_at
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal was_updated_at.to_i, release.updated_at.to_i
  end

  def test_get_download_does_not_generate_release_if_already_generated_for_provided_format
    skip 'This is a test for Release#generate_in_background!'
  end

  def test_get_download_does_not_change_counter_if_release_without_file_in_provided_format
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac', generated: true )
    release.remove_file!
    refute release.file?
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 0, release.downloads
  end

  def test_xhr_get_download_does_not_change_counter_if_release_without_file_in_provided_format
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac', generated: true )
    release.remove_file!
    refute release.file?
    assert_equal 0, release.downloads
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 0, release.downloads
  end

  def test_get_download_increments_counter_if_release_in_provided_format_exists
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac' )
    assert release.file?
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 1, release.downloads
  end

  def test_xhr_get_download_increments_counter_if_release_in_provided_format_exists
    album = Album.sham!( :published )
    release = Release.sham!( owner: album, format: 'flac' )
    assert release.file?
    assert_equal 0, release.downloads
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 1, release.downloads
  end
end
