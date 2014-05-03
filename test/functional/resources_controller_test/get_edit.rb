module ResourcesControllerTest
  module GetEdit
    def test_get_edit_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :edit, :id => resource_class.sham!.to_param
      end
    end

    def test_get_edit_for_guest_is_denied
      resource = resource_class.sham!
      assert_raises User::AccessDenied do
        get :edit, artist_id: resource.artist.to_param, :id => resource.to_param
      end
    end

    def test_get_edit_for_user_is_denied
      resource = resource_class.sham!
      login( User.sham! )
      assert_raises User::AccessDenied do
        get :edit, artist_id: resource.artist.to_param, :id => resource.to_param
      end
    end

    def test_get_edit_for_artist_user_succeeds
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, artist_id: resource.artist.to_param, id: resource.to_param
      assert_response :success
    end

    def test_get_edit_for_artist_user_displays_headers
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select "title", build_title( resource.title, resource.artist.name )
      assert_select "h1", resource.artist.name
      assert_select "h2", resource.title
    end

    def test_get_edit_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select 'a[href=?]', send( "artist_#{resource_name}_path", membership.artist, resource ), I18n.t( 'action.cancel_edit' )
    end
  end
end

