module ResourcesControllerTest
  module GetNew
    def test_get_new_for_guest_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_get_new_for_user_succeeds
      login( User.sham! )
      get :new
      assert_response :success
    end

    def test_get_new_for_user_in_artist_scope_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        get :new, :artist_id => Artist.sham!.to_param
      end
    end

    def test_get_new_for_artist_user_succeeds
      membership = Membership.sham!
      login( membership.user )
      get :new
      assert_response :success
    end

    def test_get_new_for_artist_user_displays_headers
      login( User.sham!(:admin) )
      get :new
      assert_select "title", build_title( I18n.t( "helpers.title.#{resource_name}.new" ) )
      assert_select "h1", I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select "h2", I18n.t( "helpers.title.#{resource_name}.new" )
    end

    def test_get_new_for_artist_user_displays_on_form_only_available_artists
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      Artist.sham!
      available_artists = [membership.artist]
      get :new
      assert_select 'form' do
        assert_select 'select[name=?]', "#{resource_name}[artist_id]" do
          available_artists.each do |artist|
            assert_select 'option[value=?]', artist.id, artist.name
          end
          (Artist.all - available_artists).each do |artist|
            assert_select 'option', { text: artist.name, count: 0 }
          end
        end
      end
    end

    def test_get_new_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      get :new
      assert_select 'a[href=?]', send( "#{resource_name.pluralize}_path" ), I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_for_artist_user_in_artist_scope_assigns_to_artist
      membership = Membership.sham!
      login( membership.user )
      get :new, :artist_id => membership.artist.to_param
      assert_equal membership.artist, assigns( resource_name.to_sym ).artist
    end

    def test_get_new_for_artist_user_in_artist_scope_displays_headers_with_artist
      membership = Membership.sham!
      login( membership.user )
      get :new, :artist_id => membership.artist.to_param
      assert_select "title", build_title( I18n.t( "helpers.title.#{resource_name}.new" ), membership.artist.name )
      assert_select "h1", I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select "h2", I18n.t( "helpers.title.#{resource_name}.new" )
    end

    def test_get_new_for_artist_user_in_artist_scope_selects_artist_on_form
      membership = Membership.sham!
      login( membership.user )
      get :new, :artist_id => membership.artist.to_param
      assert_select 'form' do
        assert_select 'select[name=?]', "#{resource_name}[artist_id]" do
          assert_select 'option[value=?][selected=?]', membership.artist.id, 'selected',  membership.artist.name
        end
      end
    end
  end
end

