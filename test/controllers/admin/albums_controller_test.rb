# frozen_string_literal: true

require 'test_helper'

class Admin::AlbumsControllerTest < ActionController::TestCase
  def test_authorized_delete_destroy_properly_redirects
    login_user
    album = Album.sham!
    delete :destroy, params: { artist_id: album.artist.to_param, id: album.to_param }
    assert_redirected_to artist_albums_path(album.artist)
  end
end
