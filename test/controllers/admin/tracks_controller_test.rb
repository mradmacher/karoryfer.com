# frozen_string_literal: true

require 'test_helper'

class Admin::TracksControllerTest < ActionController::TestCase
  def setup
    login_user
  end

  def test_get_edit_succeeds
    track = Track.sham!
    get :edit,
        params: {
          artist_id: track.album.artist.to_param,
          album_id: track.album.to_param,
          id: track.to_param
        }
    assert_response :success
  end

  def test_delete_destroy_succeeds
    track = Track.sham!
    assert_equal 1, Track.count
    delete :destroy,
           params: {
             artist_id: track.album.artist.to_param,
             album_id: track.album.to_param,
             id: track.to_param
           }
    assert_equal 0, Track.count
    assert_response :redirect
  end

  def test_post_create_succeeds
    album = Album.sham!
    track = Track.sham!(:build)
    assert_equal 0, Track.count
    post :create,
         params: {
           artist_id: album.artist.to_param,
           album_id: album.to_param,
           track: track.attributes
         }
    assert_equal 1, Track.count
    assert_response :redirect
  end

  def test_put_update_succeeds
    track = Track.sham!
    put :update,
        params: {
          artist_id: track.album.artist.to_param,
          album_id: track.album.to_param,
          id: track.to_param,
          track: track.attributes
        }
    assert_response :redirect
  end
end
