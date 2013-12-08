require 'test_helper'

module AlbumsControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = AlbumsController.new
      activate_authlogic
      @user = User.sham!( :admin )
      UserSession.create @user
    end

    def test_get_index_displays_unpublished
      5.times { Album.sham!( :published ) }
      5.times { Album.sham!( :unpublished ) }
      get :index
      Album.unpublished.each do |a|
        assert_select "a", a.title
      end
    end

    def test_get_show_for_unpublished_succeeds
      album = Album.sham!( :unpublished )
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.album.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.album.index' )
      assert_select "h2", I18n.t( 'helpers.title.album.new' )
    end

    def test_get_new_displays_form
      get :new
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'helpers.label.album.title' )
        assert_select 'input[type=text][name=?]', 'album[title]'
        assert_select 'label', I18n.t( 'helpers.label.album.artist_id' )
        assert_select 'label', I18n.t( 'helpers.label.album.published' )
        Artist.all.each do |g|
          assert_select 'option[value=?]', g.id, g.name
        end
        assert_select 'label', I18n.t( 'helpers.label.album.year' )
        assert_select 'input[type=number][name=?]', 'album[year]'
        assert_select 'label', I18n.t( 'helpers.label.album.image' )
        assert_select 'input[type=file][name=?]', 'album[image]'
        assert_select 'select[name=?]', 'album[license_id]' do
          assert_select 'option[value=?]', ''
          License::all.each do |license|
            assert_select 'option[value=?]', license.id, license.name
          end
        end
        assert_select 'label', I18n.t( 'helpers.label.album.donation' )
        assert_select 'textarea[name=?]', 'album[donation]'
        assert_select 'label', I18n.t( 'helpers.label.album.description' )
        assert_select 'textarea[name=?]', 'album[description]'
        assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
      end
    end

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', albums_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_edit_succeeds
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_response :success
    end

    def test_get_edit_displays_headers
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.album.edit' ), album.title, album.artist.name )
      assert_select "h1", I18n.t( 'helpers.title.album.index' )
      assert_select "h2", I18n.t( 'helpers.title.album.edit' )
    end

    def test_get_edit_displays_form
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'helpers.label.album.title' )
        assert_select 'input[type=text][name=?][value=?]', 'album[title]', album.title
        assert_select 'label', I18n.t( 'helpers.label.album.published' )
        assert_select 'label', I18n.t( 'helpers.label.album.artist_id' )
        Artist.all.each do |g|
          assert_select 'option[value=?]', g.id, g.name
        end
        assert_select 'option[value=?][selected]', album.artist_id
        assert_select 'label', I18n.t( 'helpers.label.album.year' )
        assert_select 'input[type=number][name=?][value=?]', 'album[year]', album.year
        assert_select 'label', I18n.t( 'helpers.label.album.image' )
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
        assert_select 'label', I18n.t( 'helpers.label.album.donation' )
        assert_select 'textarea[name=?]', 'album[donation]', album.donation
        assert_select 'label', I18n.t( 'helpers.label.album.description' )
        assert_select 'textarea[name=?]', 'album[description]', album.description
        assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
      end
    end

    def test_get_edit_displays_actions
      album = Album.sham!
      get :edit, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', album_path( album ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_index_displays_actions
      get :index
      assert_select 'a[href=?]', new_album_path, I18n.t( 'helpers.action.album.new' )
    end

    def test_get_show_displays_actions
      album = Album.sham!
      get :show, :artist_id => album.artist.to_param, :id => album.to_param
      assert_select 'a[href=?]', edit_artist_album_path, I18n.t( 'helpers.action.album.edit' )
      #assert_select 'a[href=?][data-method=delete]', album_path( album ), I18n.t( 'helpers.action.album.destroy' )
      assert_select 'a[href=?][data-method=delete]', album_path( album ), 0
    end

    def test_post_create_creates_album
      album = Album.sham!( :build )
      albums_count = Album.count
      post :create, :album => album.attributes
      assert_equal albums_count + 1, Album.count
      assert_redirected_to artist_album_url( album.artist, assigns( :album ) )
    end

    def test_put_update_updates_album
      album = Album.sham!
      title = Faker::Name.name
      put :update, :id => album.to_param, :album => {:title => title}
      album.reload
      assert_equal title, album.title
      assert_redirected_to artist_album_url( album.artist, album )
    end
  end
end

