require 'test_helper'

module VideosControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = VideosController.new
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_video_path, 0
    end

    def test_get_show_does_not_display_actions
      video = Video.sham!
      get :show, :id => video.to_param
      assert_select 'a[href=?]', new_video_path, 0
      assert_select 'a[href=?]', edit_video_path, 0
      assert_select 'a[href=?][data-method=delete]', video_path( video ), 0
    end

    def test_get_edit_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit, :id => Video.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises CanCan::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises CanCan::AccessDenied do
        put :update, :id => Video.sham!.id, :video => {}
      end
    end

    def test_post_create_is_denied
      assert_raises CanCan::AccessDenied do
        post :create, :video => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises CanCan::AccessDenied do
        delete :destroy, :id => Video.sham!.to_param
      end
    end
  end
end

