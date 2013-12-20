module ResourcesControllerTest
  module PutUpdate
    def test_put_update_for_guest_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => resource_class.sham!.id, resource_name.to_sym => {}
      end
    end

    def test_put_update_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        put :update, :id => resource_class.sham!.id, resource_name.to_sym => {}
      end
    end

    def test_put_update_for_artist_user_updates_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      title  = Faker::Name.name
      put :update, :id => resource.to_param, resource_name.to_sym => { title: title }
      resource = resource.reload
      assert_equal title, resource.title
      assert_redirected_to send( "artist_#{resource_name}_url", resource.artist, resource )
    end
  end
end

