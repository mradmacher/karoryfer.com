module ResourcesControllerTest
  module GetIndex
    def test_get_index_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :index
      end
    end

    def test_get_index_for_guest_does_not_display_actions
      artist = Artist.sham!
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
    end

    def test_get_index_for_user_does_not_display_actions
      artist = Artist.sham!
      login_user
      get :index, artist_id: artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", artist), 0
    end

    def test_get_index_for_artist_user_displays_actions
      membership = login_artist_user
      get :index, artist_id: membership.artist.to_param
      assert_select 'a[href=?]', send("new_artist_#{resource_name}_path", membership.artist ),
        I18n.t( "action.new" )
    end

    def test_get_index_for_guest_displays_resources_only_for_given_artist
      expected = []
      other = []
      artist = Artist.sham!
      5.times{ expected << resource_class.sham!( artist: artist ) }
      5.times{ other << resource_class.sham! }
      get :index, artist_id: artist.to_param
      expected.each do |r|
        assert_select "a", r.title
      end
      other.each do |r|
        assert_select "a", {text: r.title, count: 0}
      end
    end
  end
end

