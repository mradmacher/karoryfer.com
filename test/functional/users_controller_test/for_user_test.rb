require 'test_helper'

module UsersControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = UsersController.new
      activate_authlogic
      @user = User.sham!
      @other_user = User.sham!
      UserSession.create @user
    end

    def test_get_show_account_succeeds
      get :show, :id => @user.to_param
      assert_response :success
    end

    def test_get_edit_account_succeeds
      get :edit, :id => @user.to_param
      assert_response :success
    end

    def test_get_edit_password_succeeds
      get :edit_password, :id => @user.to_param
      assert_response :success
    end

    def test_get_show_displays_headers
      get :show, :id => @user.to_param
      assert_title @user.login, I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login
    end

    def test_get_edit_displays_headers
      get :edit, :id => @user.to_param
      assert_title I18n.t( 'helpers.title.user.edit' ), @user.login, I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login, I18n.t( 'helpers.title.user.edit' )
    end

    def test_get_edit_password_displays_headers
      get :edit_password, :id => @user.to_param
      assert_title I18n.t( 'helpers.title.user.edit_password' ), @user.login, I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login, I18n.t( 'helpers.title.user.edit_password' )
    end

    def test_get_edit_does_not_display_admin_field
      get :edit, :id => @user.to_param
      assert_select 'form > input[name=?]', 'user[admin]', 0
    end

    def test_get_index_is_denied
      assert_raises User::AccessDenied do
        get :index
      end
    end

    def test_get_show_for_other_user_is_denied
      assert_raises User::AccessDenied do
        get :show, :id => User.sham!.to_param
      end
    end

    def test_get_edit_for_other_user_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => User.sham!.to_param
      end
    end

    def test_get_edit_password_for_other_user_is_denied
      assert_raises User::AccessDenied do
        get :edit_password, :id => User.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :user => User.sham!(:build).attributes
      end
    end

    def test_put_update_for_other_user_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => User.sham!.to_param, :user => {}
      end
    end

    def test_delete_destroy_for_other_user_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => User.sham!.to_param
      end
    end
  end
end

