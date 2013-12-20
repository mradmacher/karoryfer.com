module ResourcesControllerTest
  module GetShow
    def test_get_show_for_guest_redirects_to_artists_scope
      resource = resource_class.sham!
      get :show, :id => resource.to_param
      assert_redirected_to send( "artist_#{resource_name}_url", resource.artist, resource )
    end

    def test_get_show_for_guest_succeeds
      resource = resource_class.sham!
      get :show, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_response :success
    end

    def test_get_show_for_guest_displays_headers
      resource = resource_class.sham!
      get :show, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_select "title", build_title( resource.title, resource.artist.name )
      assert_select 'h1', resource.artist.name
      assert_select 'h2', I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select 'h3', resource.title
    end

    def test_get_show_for_user_does_not_display_actions
      login( User.sham! )
      resource = resource_class.sham!
      get :show, :id => resource.to_param
      assert_select 'a[href=?]', send( "new_#{resource_name}_path" ), 0
      assert_select 'a[href=?]', send( "edit_#{resource_name}_path" ), 0
      assert_select 'a[href=?][data-method=delete]', send( "#{resource_name}_path", resource ), 0
    end

    def test_get_show_for_guest_does_not_display_actions
      resource = resource_class.sham!
      get :show, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_select 'a[href=?]', send( "new_#{resource_name}_path" ), 0
      assert_select 'a[href=?]', send( "edit_#{resource_name}_path" ), 0
      assert_select 'a[href=?][data-method=delete]', send( "#{resource_name}_path", resource ), 0
    end

    def test_get_show_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :show, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_select 'a[href=?]', send( "new_#{resource_name}_path" ), I18n.t( "helpers.action.#{resource_name}.new" )
      assert_select 'a[href=?]', send( "edit_#{resource_name}_path" ), I18n.t( "helpers.action.#{resource_name}.edit" )
      assert_select 'a[href=?][data-method=delete]', send( "#{resource_name}_path", resource ),
        I18n.t( "helpers.action.#{resource_name}.destroy" )
    end
  end
end

