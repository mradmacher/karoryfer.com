module AlbumsControllerTests
  module GetNew
    def test_get_new_for_guest_is_denied
      assert_raises User::AccessDenied do
        get :new, artist_id: Artist.sham!.to_param
      end
    end

    def test_get_new_for_user_is_denied
      login_user
      assert_raises User::AccessDenied do
        get :new, artist_id: Artist.sham!.to_param
      end
    end

    def test_get_for_admin_new_succeeds
      login_admin
      get :new, artist_id: Artist.sham!.to_param
      assert_response :success
    end

    def test_get_new_for_admin_displays_headers
      login_admin
      artist = Artist.sham!
      get :new, artist_id: artist.to_param
      title = CGI.escape_html( build_title( I18n.t( 'title.album.new' ), artist.name ) )
      assert_select "title", CGI.escape_html( build_title( I18n.t( 'title.album.new' ), artist.name ) )
      assert_select "h1", artist.name
      assert_select "h2", CGI.escape_html( I18n.t( 'title.album.new' ) )
    end

    def test_get_new_for_admin_displays_form
      login_admin
      get :new, artist_id: Artist.sham!.to_param
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'label.album.title' )
        assert_select 'input[type=text][name=?]', 'album[title]'
        assert_select 'label', I18n.t( 'label.album.published' )
        assert_select 'label', I18n.t( 'label.album.year' )
        assert_select 'input[type=number][name=?]', 'album[year]'
        assert_select 'label', I18n.t( 'label.album.image' )
        assert_select 'input[type=file][name=?]', 'album[image]'
        assert_select 'select[name=?]', 'album[license_id]' do
          assert_select 'option[value=?]', ''
          License::all.each do |license|
            assert_select 'option[value=?]', license.id, license.name
          end
        end
        assert_select 'label', I18n.t( 'label.album.donation' )
        assert_select 'textarea[name=?]', 'album[donation]'
        assert_select 'label', I18n.t( 'label.album.description' )
        assert_select 'textarea[name=?]', 'album[description]'
        assert_select 'button[type=submit]'
      end
    end

    def test_get_new_for_admin_displays_actions
      login_admin
      artist = Artist.sham!
      get :new, artist_id: artist.to_param
      assert_select 'a[href=?]', artist_path( artist ), I18n.t( 'action.cancel_new' )
    end
  end
end

