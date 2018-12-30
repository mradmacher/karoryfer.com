# frozen_string_literal: true

require 'test_helper'

class Admin::AttachmentsControllerTest < ActionController::TestCase
  def setup
    login_user
  end

  def test_get_edit_is_not_routable
    attachment = Attachment.sham!
    assert_raises ActionController::UrlGenerationError do
      get :edit,
          artist_id: attachment.album.artist.to_param,
          album_id: attachment.album.to_param,
          id: attachment.to_param
    end
  end

  def test_get_index_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      get :index
    end
  end

  def test_post_create_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      post :create, attachment: { a: 1 }
    end
  end

  def test_put_update_is_not_routable
    attachment = Attachment.sham!
    assert_raises ActionController::UrlGenerationError do
      put :update,
          artist_id: attachment.album.artist.to_param,
          album_id: attachment.album.to_param,
          id: attachment.to_param
    end
  end

  def test_delete_destroy_without_album_is_not_routable
    assert_raises ActionController::UrlGenerationError do
      delete :destroy, id: 1
    end
  end

  def test_delete_destroy_succeeds
    attachment = Attachment.sham!
    assert_equal 1, Attachment.count
    delete :destroy,
           artist_id: attachment.album.artist.to_param,
           album_id: attachment.album.to_param,
           id: attachment.to_param
    assert_equal 0, Attachment.count
    assert_response :redirect
  end

  def test_post_create_succeeds
    album = Album.sham!
    attachment = Attachment.sham!(:build, album: album)
    assert_equal 0, Attachment.count
    post :create,
         artist_id: album.artist.to_param,
         album_id: album.to_param,
         attachment: attachment.attributes
    assert_equal 1, Attachment.count
    assert_response :redirect
  end
end
