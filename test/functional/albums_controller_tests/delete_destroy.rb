module AlbumsControllerTests
  module DeleteDestroy
    def test_delete_destroy_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        delete :destroy, :id => 1
      end
    end

    def test_authorized_delete_destroy_removes_album
      album = Album.sham!
      allow(:write, album)
      album_count = Album.count
      delete :destroy, artist_id: album.artist.to_param, :id => album.to_param
      assert_equal album_count - 1, Album.count
      refute Album.where( id: album.id ).exists?
    end

    def test_authorized_delete_destroy_properly_redirects
      album = Album.sham!
      allow(:write, album)
      delete :destroy, artist_id: album.artist.to_param, id: album.to_param
      assert_redirected_to artist_albums_path( album.artist )
    end
  end
end

