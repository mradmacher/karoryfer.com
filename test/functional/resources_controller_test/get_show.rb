module ResourcesControllerTest
  module GetShow
    def test_get_edit_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :show, :id => resource_class.sham!.to_param
      end
    end

    def test_get_show_for_guest_succeeds
      resource = resource_class.sham!
      get :show, artist_id: resource.artist.to_param, id: resource.to_param
      assert_response :success
    end

    def test_get_show_for_guest_displays_headers
      resource = resource_class.sham!
      get :show, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select "title", build_title( resource.title, resource.artist.name )
      assert_select 'h1', resource.artist.name
      assert_select 'h2', I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select 'h3', resource.title
    end

    def test_get_show_for_guest_does_not_display_actions
      resource = resource_class.sham!
      get :show, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select 'a[href=?]', send( "new_artist_#{resource_name}_path", resource.artist ), 0
      assert_select 'a[href=?]', send( "edit_artist_#{resource_name}_path", resource.artist, resource ), 0
      assert_select 'a[href=?][data-method=delete]', send( "artist_#{resource_name}_path", resource.artist, resource ), 0
    end

    def test_get_show_for_user_does_not_display_actions
      login( User.sham! )
      resource = resource_class.sham!
      get :show, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select 'a[href=?]', send( "new_artist_#{resource_name}_path", resource.artist ), 0
      assert_select 'a[href=?]', send( "edit_artist_#{resource_name}_path", resource.artist, resource ), 0
      assert_select 'a[href=?][data-method=delete]', send( "artist_#{resource_name}_path", resource.artist, resource ), 0
    end

    def test_get_show_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :show, artist_id: resource.artist.to_param, id: resource.to_param
      assert_select 'a[href=?]', send( "new_artist_#{resource_name}_path", resource.artist ), I18n.t( "helpers.action.#{resource_name}.new" )
      assert_select 'a[href=?]', send( "edit_artist_#{resource_name}_path", resource.artist, resource ), I18n.t( "helpers.action.#{resource_name}.edit" )
      assert_select 'a[href=?][data-method=delete]', send( "artist_#{resource_name}_path", resource.artist, resource ),
        I18n.t( "helpers.action.#{resource_name}.destroy" )
    end
  end
end

