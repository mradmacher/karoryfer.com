module AlbumsControllerTests
  module PutUpdate
    def test_put_update_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        put :update, :id => 1, :album => {}
      end
    end

    def test_put_update_for_guest_is_denied
      album = Album.sham!
      assert_raises User::AccessDenied do
        put :update, artist_id: album.artist.to_param, :id => album.to_param, :album => {}
      end
    end

    def test_put_update_for_user_is_denied
      login( User.sham! )
      album = Album.sham!
      assert_raises User::AccessDenied do
        put :update, artist_id: album.artist.to_param, :id => album.to_param, :album => {}
      end
    end

    def test_put_update_for_artist_user_is_denied
      membership = Membership.sham!
      login( membership.user )
      album = Album.sham!( artist: membership.artist )
      assert_raises User::AccessDenied do
        put :update, artist_id: album.artist.to_param, :id => album.to_param, :album => {}
      end
    end

    def test_put_update_for_admin_updates_album
      login( User.sham!( :admin ) )
      album = Album.sham!
      title = Faker::Name.name
      put :update, artist_id: album.artist.to_param, :id => album.to_param, :album => {:title => title}
      album.reload
      assert_equal title, album.title
      assert_redirected_to artist_album_url( album.artist, album )
    end

    def test_put_update_for_admin_does_not_change_artist
      login( User.sham!( :admin ) )
      artist = Artist.sham!
      album = Album.sham!( artist: artist )
      other_artist = Artist.sham!
      put :update, artist_id: artist.to_param, id: album.to_param, album: { artist_id: other_artist.id }
      album = album.reload
      assert_equal artist, album.artist
    end
  end
end

