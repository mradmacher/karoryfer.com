require 'spawnling'
require 'test_helper'
require_relative 'albums_controller_tests/get_index'
require_relative 'albums_controller_tests/get_show'
require_relative 'albums_controller_tests/get_edit'
require_relative 'albums_controller_tests/get_new'
require_relative 'albums_controller_tests/put_update'
require_relative 'albums_controller_tests/post_create'
require_relative 'albums_controller_tests/delete_destroy'

class AlbumsControllerTest < ActionController::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  include AlbumsControllerTests::GetIndex
  include AlbumsControllerTests::GetShow
  include AlbumsControllerTests::GetEdit
  include AlbumsControllerTests::GetNew
  include AlbumsControllerTests::PutUpdate
  include AlbumsControllerTests::PostCreate
  include AlbumsControllerTests::DeleteDestroy

  def test_get_download_redirects_to_album_if_no_release_in_provided_format
    album = Album.sham!( :published )
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to artist_album_url( album.artist, album )
  end

  def test_xhr_get_download_returns_false_if_no_release_in_provided_format
    album = Album.sham!( :published )
    xhr :get, :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_response :success
    result = JSON.parse(response.body)
    assert_equal false, result['success']
  end

  def test_get_download_redirects_to_release_url_if_release_in_provided_format_exists
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    release = track.album.releases.create(format: 'flac')
    get :download, artist_id: release.album.artist.to_param, id: release.album.to_param, format: 'flac'
    assert_redirected_to release.file.url
  end

  def test_xhr_get_download_returns_release_url_if_release_in_provided_format_exists
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    release = track.album.releases.create(format: 'flac')
    xhr :get, :download, artist_id: release.album.artist.to_param, id: release.album.to_param, format: 'flac'
    assert_response :success

    result = JSON.parse(response.body)
    assert_equal true, result['success']
    assert_equal release.file.url, result['url']
  end

  def test_post_release_redirects_to_album
    Spawnling.default_options( { :method => :yield } )
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album
    post :release, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to artist_album_path( album.artist, album )
  end

  def test_post_release_json_returns_true
    Spawnling.default_options( { :method => :yield } )
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album
    xhr :post, :release, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    result = JSON.parse(response.body)
    assert_equal true, result['success']
  end

  def test_post_release_generates_release_if_none_in_provided_format
    Spawnling.default_options( { :method => :yield } )
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album

    refute album.releases.in_format( 'flac' ).exists?
    post :release, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert album.releases.in_format( 'flac' ).exists?
  end

  def test_post_release_does_not_generate_release_if_exists_in_provided_format
    Spawnling.default_options( { :method => :yield } )
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album
    album.releases.create( format: 'flac' )

    assert_equal 1, album.releases.in_format( 'flac' ).count
    post :release, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_equal 1, album.releases.in_format( 'flac' ).count
  end

  def test_post_release_does_not_generate_release_if_already_generated_for_provided_format
    skip "I don't know how to test it"
  end

  def test_post_release_updates_release_timestamp
    Spawnling.default_options( { :method => :yield } )
    track = Track.sham!  file: File.open( File.join( FIXTURES_DIR, 'tracks', '1.wav' ) )
    album = track.album
    now = Time.now
    release = album.releases.create( format: 'flac', updated_at: now - 10.days )

    refute_in_delta release.updated_at.to_i, now.to_i, 1
    post :release, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_in_delta release.updated_at.to_i, now.to_i, 1
  end
end

