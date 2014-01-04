module ResourcesControllerTest
  module GetIndex
    def test_get_index_for_guest_succeeds
      get :index
      assert_response :success
    end

    def test_get_index_for_user_succeeds
      login( User.sham! )
      get :index
      assert_response :success
    end

    def test_get_index_for_guest_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( "helpers.title.#{resource_name}.index" ) )
      assert_select 'h1', I18n.t( "helpers.title.#{resource_name}.index" )
    end

    def test_get_index_for_guest_does_not_display_actions
      artist = Artist.sham!
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
    end

    def test_get_index_for_user_does_not_display_actions
      artist = Artist.sham!
      login( User.sham! )
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
    end

    def test_get_index_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      get :index, artist_id: membership.artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", membership.artist ),
        I18n.t( "helpers.action.#{resource_name}.new" )
    end
  end
end

