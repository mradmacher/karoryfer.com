module AlbumsControllerTests
  module PostCreate
    def test_post_create_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        post :create, :album => {}
      end
    end

    def test_authorized_post_create_creates_album
      album = Album.sham!( :build )
      allow(:write, Album, album.artist)
      albums_count = Album.count
      post :create, artist_id: album.artist.to_param, :album => album.attributes
      assert_equal albums_count + 1, Album.count
      assert_redirected_to artist_album_url( album.artist, assigns( :album ) )
    end

    def test_authorized_post_create_does_not_change_artist
      artist = Artist.sham!
      allow(:write, Album, artist)
      other_artist = Artist.sham!
      album = Album.sham!( :build, artist: other_artist )
      post :create, artist_id: artist.to_param, album: album.attributes
      album = Album.order('created_at desc').first
      assert_equal artist, album.artist
    end
  end
end

