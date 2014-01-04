module ResourcesControllerTest
  module PostCreate
    def test_post_create_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        post :create, resource_name.to_sym => {}
      end
    end

    def test_post_create_for_guest_is_denied
      assert_raises User::AccessDenied do
        post :create, artist_id: Artist.sham!.to_param, resource_name.to_sym => {}
      end
    end

    def test_post_create_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        post :create, artist_id: Artist.sham!.to_param, resource_name.to_sym => {}
      end
    end

    def test_post_create_for_artist_user_creates_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( :build, artist: membership.artist )
      resource_count = resource_class.count
      post :create, artist_id: resource.artist.to_param, resource_name.to_sym => resource.attributes
      assert_equal resource_count + 1, resource_class.count
      assert_redirected_to send( "artist_#{resource_name}_url", resource.artist, assigns( resource_name.to_sym ) )
    end

    def test_post_create_for_artist_user_does_not_change_artist
      membership = Membership.sham!
      login( membership.user )
      artist = membership.artist
      other_artist = Artist.sham!
      resource = resource_class.sham!( :build, artist: other_artist )
      post :create, artist_id: artist.to_param, resource_name.to_sym => resource.attributes
      resource = resource_class.order('created_at desc').first
      assert_equal artist, resource.artist
    end
  end
end

