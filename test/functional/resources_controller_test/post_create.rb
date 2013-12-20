module ResourcesControllerTest
  module PostCreate
    def test_post_create_for_guest_is_denied
      assert_raises User::AccessDenied do
        post :create, resource_name.to_sym => {}
      end
    end

    def test_post_create_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        post :create, resource_name.to_sym => resource_class.sham!( :build ).attributes
      end
    end

    def test_post_create_for_artist_user_creates_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( :build, artist: membership.artist )
      resource_count = resource_class.count
      post :create, resource_name.to_sym => resource.attributes
      assert_equal resource_count + 1, resource_class.count
      assert_redirected_to send( "artist_#{resource_name}_url", resource.artist, assigns( resource_name.to_sym ) )
    end
  end
end

