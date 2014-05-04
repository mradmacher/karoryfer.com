module AlbumsControllerTests
  module GetEdit
    def test_get_edit_without_artist_is_not_routable
      assert_raises ActionController::RoutingError do
        get :edit, :id => '1'
      end
    end

    def test_get_edit_for_guest_is_denied
      album = Album.sham!
      assert_raises User::AccessDenied do
        get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      end
    end

    def test_get_edit_for_user_is_denied
      login_user
      album = Album.sham!
      assert_raises User::AccessDenied do
        get :edit, :artist_id => album.artist.to_param, :id => album
      end
    end

    def test_get_edit_for_artist_user_is_denied
      membership = login_artist_user
      album = Album.sham!( artist: membership.artist )
      assert_raises User::AccessDenied do
        get :edit, :artist_id => album.artist.to_param, :id => album
      end
    end

    def test_get_edit_for_admin_succeeds
      login_admin
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_edit_for_admin_displays_headers
      login_admin
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select "title", build_title( album.title, album.artist.name )
      assert_select 'h1', album.artist.name
      assert_select 'h2', album.title
    end

    def test_get_edit_for_admin_displays_form
      login_admin
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'label.album.title' )
        assert_select 'input[type=text][name=?][value=?]', 'album[title]', album.title
        assert_select 'label', I18n.t( 'label.album.published' )
        assert_select 'label', I18n.t( 'label.album.year' )
        assert_select 'input[type=number][name=?][value=?]', 'album[year]', album.year
        assert_select 'label', I18n.t( 'label.album.image' )
        assert_select 'input[type=file][name=?]', 'album[image]'
        assert_select 'select[name=?]', 'album[license_id]' do
          assert_select 'option[value=?]', ''
          License.all.each do |license|
            if album.license == license
              assert_select 'option[value=?][selected=selected]', license.id, license.name
            else
              assert_select 'option[value=?][selected=selected]', license.id, 0
              assert_select 'option[value=?]', license.id, license.name
            end
          end
        end
        assert_select 'label', I18n.t( 'label.album.donation' )
        assert_select 'textarea[name=?]', 'album[donation]', album.donation
        assert_select 'label', I18n.t( 'label.album.description' )
        assert_select 'textarea[name=?]', 'album[description]', album.description
        assert_select 'button[type=submit]'
      end
    end

    def test_get_edit_for_admin_displays_actions
      login_admin
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', artist_album_path( album.artist, album ), I18n.t( 'action.cancel_edit' )
    end
  end
end

