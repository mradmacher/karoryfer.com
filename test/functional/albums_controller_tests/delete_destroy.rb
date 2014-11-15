module AlbumsControllerTests
  module DeleteDestroy
    def test_delete_destroy_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        delete :destroy, :id => 1
      end
    end

    def test_authorized_delete_destroy_properly_redirects
      album = Album.sham!
      allow(:write, album)
      delete :destroy, artist_id: album.artist.to_param, id: album.to_param
      assert_redirected_to artist_albums_path( album.artist )
    end
  end
end
