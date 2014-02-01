module AlbumsControllerTests
  module PostCreate
    def test_post_create_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        post :create, :album => {}
      end
    end

    def test_post_create_for_guest_is_denied
      assert_raises User::AccessDenied do
        post :create, artist_id: Artist.sham!.to_param, :album => {}
      end
    end

    def test_post_create_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        post :create, artist_id: Artist.sham!.to_param, :album => Album.sham!( :build ).attributes
      end
    end

    def test_post_create_for_artist_user_is_denied
      membership = Membership.sham!
      login( membership.user )
      assert_raises User::AccessDenied do
        album = Album.sham!( :build, artist: membership.artist )
        post :create, artist_id: album.artist.to_param, :album => album.attributes
      end
    end

    def test_post_create_for_admin_creates_album
      login( User.sham!( :admin ) )
      album = Album.sham!( :build )
      albums_count = Album.count
      post :create, artist_id: album.artist.to_param, :album => album.attributes
      assert_equal albums_count + 1, Album.count
      assert_redirected_to artist_album_url( album.artist, assigns( :album ) )
    end

    def test_post_create_for_admin_does_not_change_artist
      login( User.sham!( :admin ) )
      artist = Artist.sham!
      other_artist = Artist.sham!
      album = Album.sham!( :build, artist: other_artist )
      post :create, artist_id: artist.to_param, album: album.attributes
      album = Album.order('created_at desc').first
      assert_equal artist, album.artist
    end
  end
end

