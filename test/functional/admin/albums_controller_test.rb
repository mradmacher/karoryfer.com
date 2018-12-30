# frozen_string_literal: true

require 'test_helper'

class Admin::AlbumsControllerTest < ActionController::TestCase

  def test_delete_destroy_without_artist_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: 1
    end
  end

  def test_authorized_delete_destroy_properly_redirects
    login_user
    album = Album.sham!
    delete :destroy, artist_id: album.artist.to_param, id: album.to_param
    assert_redirected_to artist_albums_path(album.artist)
  end

  def test_get_edit_without_artist_is_not_routable
    assert_raise ActionController::UrlGenerationError do
      get :edit, id: '1'
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
