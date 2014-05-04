module AlbumsControllerTests
  module DeleteDestroy
    def test_delete_destroy_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        delete :destroy, :id => 1
      end
    end
    def test_delete_destroy_for_guest_is_denied
      album = Album.sham!
      assert_raises User::AccessDenied do
        delete :destroy, artist_id: album.artist.to_param, :id => album.to_param
      end
    end

    def test_delete_destroy_for_user_is_denied
      login_user
      album = Album.sham!
      assert_raises User::AccessDenied do
        delete :destroy, artist_id: album.artist.to_param, :id => album.to_param
      end
    end

    def test_delete_destroy_for_artist_user_is_denied
      membership = login_artist_user
      album = Album.sham!( artist: membership.artist )
      assert_raises User::AccessDenied do
        delete :destroy, artist_id: album.artist.to_param, :id => album.to_param
      end
    end

    def test_delete_destroy_for_admin_succeeds
      login_admin
      album = Album.sham!
      album_count = Album.count
      delete :destroy, artist_id: album.artist.to_param, :id => album.to_param
      assert_equal album_count - 1, Album.count
      refute Album.where( id: album.id ).exists?
    end

    def test_delete_destroy_for_admin_properly_redirects
      login_admin
      album = Album.sham!
      delete :destroy, artist_id: album.artist.to_param, id: album.to_param
      assert_redirected_to artist_albums_path( album.artist )
    end
  end
end

