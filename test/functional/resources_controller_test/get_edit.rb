module ResourcesControllerTest
  module GetEdit
    def test_get_edit_for_guest_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => resource_class.sham!.to_param
      end
    end

    def test_get_edit_for_user_is_denied
      login( User.sham! )
      assert_raises User::AccessDenied do
        get :edit, :id => resource_class.sham!.to_param
      end
    end

    def test_get_edit_for_artist_user_redirects_to_artist_scope
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, :id => resource.to_param
      assert_redirected_to send( "edit_artist_#{resource_name}_url", resource.artist, resource )
    end

    def test_get_edit_for_artist_user_succeeds
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_response :success
    end

    def test_get_edit_for_artist_user_displays_headers
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_select "title", build_title( I18n.t( "helpers.title.#{resource_name}.edit" ), resource.artist.name )
      assert_select "h1", resource.artist.name
      assert_select "h2", I18n.t( "helpers.title.#{resource_name}.index" )
      assert_select "h3", I18n.t( "helpers.title.#{resource_name}.edit" )
    end

    def test_get_edit_for_artist_user_displays_on_form_only_available_artists
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      Artist.sham!
      get :edit, :artist_id => resource.artist.to_param, :id => resource.to_param
      available_artists = [membership.artist]
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

    def test_get_edit_for_artist_user_displays_actions
      membership = Membership.sham!
      login( membership.user )
      resource = resource_class.sham!( artist: membership.artist )
      get :edit, :artist_id => resource.artist.to_param, :id => resource.to_param
      assert_select 'a[href=?]', send( "#{resource_name}_path", resource ), I18n.t( 'helpers.action.cancel_edit' )
    end
  end
end

