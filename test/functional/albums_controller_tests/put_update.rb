module AlbumsControllerTests
  module PutUpdate
    def test_put_update_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        put :update, :id => 1, :album => {}
      end
    end

    def test_authorized_put_update_updates_album
      album = Album.sham!
      allow(:write, album)
      title = Faker::Name.name
      put :update, artist_id: album.artist.to_param, :id => album.to_param, :album => {:title => title}
      album.reload
      assert_equal title, album.title
      assert_redirected_to artist_album_url( album.artist, album )
    end

    def test_authorized_put_update_does_not_change_artist
      artist = Artist.sham!
      album = Album.sham!( artist: artist )
      allow(:write, album)
      other_artist = Artist.sham!
      put :update, artist_id: artist.to_param, id: album.to_param, album: { artist_id: other_artist.id }
      album = album.reload
      assert_equal artist, album.artist
    end
  end
end

