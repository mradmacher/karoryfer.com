require 'test_helper'

class TracksControllerTest < ActionController::TestCase
  def test_get_edit_is_authorized
    track = Track.sham!
    assert_authorized :write_track, track.album do
      get :edit,
          artist_id: track.album.artist.to_param,
          album_id: track.album.to_param,
          id: track.to_param
    end
  end

  def test_get_show_is_authorized
    track = Track.sham!(:with_file)
    assert_authorized :read_track, track.album do
      get :show,
          artist_id: track.album.artist.to_param,
          album_id: track.album.to_param,
          id: track.to_param
    end
  end

  def test_delete_destroy_is_authorized
    track = Track.sham!
    assert_authorized :write_track, track.album do
      delete :destroy,
             artist_id: track.album.artist.to_param,
             album_id: track.album.to_param,
             id: track.to_param
    end
  end

  def test_post_create_is_authorized
    album = Album.sham!
    assert_authorized :write_track, album do
      post :create,
           artist_id: album.artist.to_param,
           album_id: album.to_param,
           track: { a: 1 }
    end
  end

  def test_put_update_is_authorized
    track = Track.sham!
    assert_authorized :write_track, track.album do
      put :update,
          artist_id: track.album.artist.to_param,
          album_id: track.album.to_param,
          id: track.to_param,
          track: { a: 1 }
    end
  end
end
