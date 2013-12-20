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
      get :index
      assert_select 'a[href=?]', send("new_#{resource_name}_path"), 0
    end

    def test_get_index_for_user_does_not_display_actions
      login( User.sham! )
      get :index
      assert_select 'a[href=?]', send("new_#{resource_name}_path"), 0
    end

    def test_get_index_for_artist_user_displays_actions
      login( Membership.sham!.user )
      get :index
      assert_select 'a[href=?]', send("new_#{resource_name}_path"),
        I18n.t( "helpers.action.#{resource_name}.new" )
    end

  end
end

