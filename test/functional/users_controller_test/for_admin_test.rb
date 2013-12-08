require 'test_helper'

module UsersControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = UsersController.new
      activate_authlogic
      @user = User.sham! :admin
      @other_user = User.sham!
      UserSession.create @user
    end

    def test_get_index_succeeds
      get :index
      assert_response :success
    end

    def test_get_show_for_other_user_succeeds
      get :show, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_edit_for_other_user_succeeds
      get :edit, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_edit_password_for_other_user_succeeds
      get :edit_password, :id => @other_user.to_param
      assert_response :success
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_title I18n.t( 'helpers.title.user.new' ), I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), I18n.t( 'helpers.title.user.new' )
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.user.index' ) )
      assert_select "h1", I18n.t( 'helpers.title.user.index' )
    end

    def test_get_edit_password_for_other_user_displays_headers
      get :edit_password, :id => @other_user.to_param
      assert_title I18n.t( 'helpers.title.user.edit_password' ), @other_user.login,
        I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @other_user.login,
        I18n.t( 'helpers.title.user.edit_password' )
    end
  end
end

