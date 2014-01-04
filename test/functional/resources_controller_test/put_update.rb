module ResourcesControllerTest
  module PutUpdate
    def test_put_update_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        put :update, id: resource_class.sham!.id, resource_name.to_sym => {}
      end
    end

    def test_put_update_for_guest_is_denied
      resource = resource_class.sham!
      assert_raises User::AccessDenied do
        put :update, artist_id: resource.artist.to_param, id: resource.to_param, resource_name.to_sym => {}
      end
    end

    def test_put_update_for_user_is_denied
      resource = resource_class.sham!
      login( User.sham! )
      assert_raises User::AccessDenied do
        put :update, artist_id: resource.artist.to_param, id: resource.to_param, resource_name.to_sym => {}
      end
    end

    def test_put_update_for_artist_user_updates_entry
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      title  = Faker::Name.name
      put :update, artist_id: resource.artist.to_param, id: resource.to_param, resource_name.to_sym => { title: title }
      resource = resource.reload
      assert_equal title, resource.title
      assert_redirected_to send( "artist_#{resource_name}_url", resource.artist, resource )
    end

    def test_put_update_for_artist_user_does_not_change_artist
      membership = Membership.sham!
      login( membership.user )
      artist = membership.artist
      resource = resource_class.sham!( artist: artist )
      other_artist = Artist.sham!
      put :update, artist_id: artist.to_param, id: resource.to_param, resource_name.to_sym => { artist_id: other_artist.id }
      resource = resource.reload
      assert_equal artist, resource.artist
    end
  end
end

