module ResourcesControllerTest
  module GetNew
    def test_get_new_without_artist_is_not_routable
      assert_raises ActionController::UrlGenerationError do
        get :new
      end
    end

    def test_get_new_for_artist_user_displays_headers
      membership = login_artist_user
      get :new, artist_id: membership.artist.to_param
      assert_select "title", CGI.escape_html( build_title( I18n.t( "title.#{resource_name}.new" ), membership.artist.name ) )
      assert_select "h1", membership.artist.name
      assert_select "h2", CGI.escape_html( I18n.t( "title.#{resource_name}.new" ) )
    end

    def test_get_new_for_artist_user_displays_actions
      membership = login_artist_user
      get :new, artist_id: membership.artist.to_param
      assert_select 'a[href=?]', send( 'artist_path', membership.artist ), I18n.t( 'action.cancel_new' )
    end

    def test_get_new_for_artist_user_assigns_artist
      membership = login_artist_user
      get :new, artist_id: membership.artist.to_param
      assert_equal membership.artist, assigns( resource_name.to_sym ).artist
    end
  end
end

