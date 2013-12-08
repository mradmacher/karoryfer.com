require 'test_helper'

module UsersControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = UsersController.new
    end

    def test_get_index_is_denied
      assert_raises CanCan::AccessDenied do
        get :index
      end
    end

    def test_get_show_is_denied
      assert_raises CanCan::AccessDenied do

        get :show, :id => User.sham!.to_param
      end
    end

    def test_get_edit_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit, :id => User.sham!.to_param
      end
    end

    def test_get_edit_password_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit_password, :id => User.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises CanCan::AccessDenied do
        get :new
      end
    end

    def test_post_create_is_denied
      assert_raises CanCan::AccessDenied do
        post :create, :user => User.sham!.attributes
      end
    end

    def test_put_update_is_denied
      assert_raises CanCan::AccessDenied do
        put :update, :id => User.sham!.to_param, :user => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises CanCan::AccessDenied do
        delete :destroy, :id => User.sham!.to_param
      end
    end
  end
end

