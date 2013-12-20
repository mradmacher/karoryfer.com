module ResourcesControllerTest
  module DeleteDestroy
    def test_delete_destroy_for_guest_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => resource_class.sham!.to_param
      end
    end

    def test_delete_destroy_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        delete :destroy, :id => resource_class.sham!.to_param
      end
    end

    def test_delete_destroy_for_artist_user_removes_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      resource_count = resource_class.count
      delete :destroy, :id => resource.to_param
      assert_equal resource_count - 1, resource_class.count
      refute resource_class.where(id: resource.id).exists?
      assert_redirected_to send( "artist_#{resource_name.pluralize}_path",  resource.artist )
    end
  end
end

