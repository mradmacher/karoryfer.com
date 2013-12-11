require 'test_helper'

module ArtistsControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = ArtistsController.new
    end

    def test_get_index_succeeds
      10.times { Artist.sham! }
      get :index
      assert_response :success
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.artist.index' ) )
      assert_select "h1", I18n.t( 'helpers.title.artist.index' )
    end

    def test_get_show_succeeds
      get :show, :id => Artist.sham!.to_param
      assert_template 'current_artist'
      assert_response :success
    end

    def test_get_show_displays_headers
      artist = Artist.sham!
      get :show, :id => artist.to_param
      assert_select "title", build_title( artist.name )
      assert_select "h1", artist.name
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_get_edit_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => Artist.sham!.to_param
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :artist => {}
      end
    end

    def test_put_update_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => Artist.sham!.to_param, :artist => {}
      end
    end

    def test_get_index_does_not_show_actions
      get :index
      assert_select 'a[href=?]', new_artist_path, 0
    end

    def test_get_show_does_not_show_actions
      artist = Artist.sham!
      get :show, :id => artist.to_param
      assert_select 'a[href=?]', edit_artist_path, 0
      assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
    end
  end
end

