require 'test_helper'

module ArtistsControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = ArtistsController.new
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
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

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_artist_path, 0
    end

    def test_get_show_does_not_display_actions
      artist = Artist.sham!
      get :show, :id => artist.to_param
      assert_select 'a[href=?]', edit_artist_path, 0
      assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
    end
  end
end

