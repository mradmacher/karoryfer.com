module ResourcesControllerTest
  module GetNew
    def test_get_new_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :new
      end
    end

    def test_get_new_for_guest_is_denied
      assert_raises User::AccessDenied do
        get :new, artist_id: Artist.sham!.to_param
      end
    end

    def test_get_new_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        get :new, artist_id: Artist.sham!.to_param
      end
    end

    def test_get_new_for_artist_user_succeeds
      membership = Membership.sham!
      login( membership.user )
      get :new, artist_id: membership.artist.to_param
      assert_response :success
    end

    def test_get_new_for_artist_user_displays_headers
      membership = Membership.sham!
      login( membership.user )
      get :new, artist_id: membership.artist.to_param
      assert_select "title", build_title( I18n.t( "helpers.title.#{resource_name}.new" ), membership.artist.name )
      assert_select "h1", membership.artist.name
      assert_select "h2", I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select "h3", I18n.t( "helpers.title.#{resource_name}.new" )
    end

    def test_get_new_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      get :new, artist_id: membership.artist.to_param
      assert_select 'a[href=?]', send( 'artist_path', membership.artist ), I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_for_artist_user_assigns_artist
      membership = Membership.sham!
      login( membership.user )
      get :new, artist_id: membership.artist.to_param
      assert_equal membership.artist, assigns( resource_name.to_sym ).artist
    end
  end
end

