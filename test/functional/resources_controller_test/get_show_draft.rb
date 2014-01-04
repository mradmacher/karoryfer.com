module ResourcesControllerTest
  module GetShowDraft
    def test_get_show_for_user_is_denied_for_unpublished
      login( User.sham! )
      resource = resource_class.sham!( published: false )
      assert_raises User::AccessDenied do
        get :show, artist_id: resource.artist.to_param, id: resource.to_param
      end
    end

    def test_get_show_for_guest_is_denied_for_unpublished
      resource = resource_class.sham!( published: false )
      assert_raises User::AccessDenied do
        get :show, artist_id: resource.artist.to_param, id: resource.to_param
      end
    end

    def test_get_show_for_artist_user_succeeds_for_unpublished
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist, published: false )
      get :show, artist_id: membership.artist.to_param, id: resource.to_param
      assert_response :success
    end
  end
end

