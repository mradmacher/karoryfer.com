module ResourcesControllerTest
  module DeleteDestroy
    def test_delete_destroy_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        delete :destroy, id: resource_class.sham!.to_param
      end
    end

    def test_delete_destroy_for_guest_is_denied
      resource = resource_class.sham!
      assert_raises User::AccessDenied do
        delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
      end
    end

    def test_delete_destroy_for_user_is_denied
      resource = resource_class.sham!
      login( User.sham! )
      assert_raises User::AccessDenied do
        delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
      end
    end

    def test_delete_destroy_for_artist_user_removes_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      resource_count = resource_class.count
      delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
      assert_equal resource_count - 1, resource_class.count
      refute resource_class.where(id: resource.id).exists?
    end

    def test_delete_destroy_for_artist_user_properly_redirects
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
      assert_redirected_to send( "artist_#{resource_name.pluralize}_path",  resource.artist )
    end
  end
end

