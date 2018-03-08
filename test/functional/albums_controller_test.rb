# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  def test_get_download_redirects_to_album_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    release.save
    refute release.file?
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to artist_album_url(album.artist, album)
  end

  def test_get_download_redirects_to_release_url_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    assert_redirected_to release.file.url
  end

  def test_get_download_does_not_change_counter_if_release_without_file_in_provided_format
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    release.remove_file!
    release.save
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 0, release.downloads
  end

  def test_get_download_increments_counter_if_release_in_provided_format_exists
    album = Album.sham!(:published)
    release = Release.sham!(album: album, format: Release::FLAC)
    assert release.file?
    assert_equal 0, release.downloads
    get :download, artist_id: album.artist.to_param, id: album.to_param, format: 'flac'
    release.reload
    assert_equal 1, release.downloads
  end

  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: 1
    end
  end

  def test_authorized_delete_destroy_properly_redirects
    album = Album.sham!
    assert_authorized do
      delete :destroy, artist_id: album.artist.to_param, id: album.to_param
    end
    assert_redirected_to artist_albums_path(album.artist)
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raise ActionController::UrlGenerationError do
      get :edit, id: '1'
    end
  end

  def test_get_index_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index, id: '1'
    end
  end

  def test_get_show_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :show, id: 'album'
    end
  end

  def test_post_create_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, album: {}
    end
  end

  def test_put_update_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      put :update, id: 1, album: {}
    end
  end
end
