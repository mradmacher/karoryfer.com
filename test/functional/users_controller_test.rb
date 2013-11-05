require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    10.times{ User.sham! }
    @user = User.first
  end

  should 'refute get index' do
    assert_raise( CanCan::AccessDenied ) do
      get :index
    end
  end

  should 'refute get show' do
    assert_raise( CanCan::AccessDenied ) do
      get :show, :id => @user.to_param
    end
  end

  should 'refute get edit' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :id => @user.to_param
    end
  end

  should 'refute edit password' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit_password, :id => @user.to_param
    end
  end

  should 'refute get new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end

  should 'refute create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :user => @user.attributes
    end
  end

  should 'refute update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => @user.to_param, :user => {}
    end
  end

  should 'refute destroy' do
    assert_raise( CanCan::AccessDenied ) do
      delete :destroy, :id => @user.to_param
    end
  end

  context 'for user' do
    setup do
      activate_authlogic
      @user = User.sham!
      @other_user = User.sham!
      UserSession.create( @user )
    end
  
    should 'show account' do
      get :show, :id => @user.to_param
      assert_response :success
    end

    should 'edit account' do
      get :edit, :id => @user.to_param
      assert_response :success
    end

    should 'edit password' do
      get :edit_password, :id => @user.to_param
      assert_response :success
    end

    should 'display headers on show page' do
      get :show, :id => @user.to_param
      assert_title @user.login, I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login
    end

    should 'display headers on edit page' do
      get :edit, :id => @user.to_param
      assert_title I18n.t( 'helpers.title.user.edit' ), @user.login, I18n.t( 'helpers.title.user.index' ) 
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login, I18n.t( 'helpers.title.user.edit' )
    end

    should 'display headers on edit password page' do
      get :edit_password, :id => @user.to_param
      assert_title I18n.t( 'helpers.title.user.edit_password' ), @user.login, I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @user.login, I18n.t( 'helpers.title.user.edit_password' )
    end

    should 'not display admin field' do
      get :edit, :id => @user.to_param
      assert_select 'form > input[name=?]', 'user[admin]', 0
    end

    should 'refute index' do
      assert_raise( CanCan::AccessDenied ) do
        get :index
      end
    end

    should 'refute show other user' do
      assert_raise( CanCan::AccessDenied ) do
        get :show, :id => @other_user.to_param
      end
    end

    should 'refute edit other user' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => @other_user.to_param
      end
    end

    should 'refute edit password for other user' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit_password, :id => @other_user.to_param
      end
    end

    should 'refute new other user' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end

    should 'refute create other user' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :user => @other_user.attributes
      end
    end

    should 'refute update other user' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => @other_user.to_param, :user => {}
      end
    end

    should 'refute destroy other user' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => @other_user.to_param
      end
    end
  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham! :admin
      @other_user = User.sham!
      UserSession.create( @user )
    end

    should 'index' do
      get :index
      assert_response :success
    end

    should 'show other user' do
      get :show, :id => @other_user.to_param
      assert_response :success
    end
    
    should 'edit other user' do
      get :edit, :id => @other_user.to_param
      assert_response :success
    end

    should 'edit other user password' do
      get :edit_password, :id => @other_user.to_param
      assert_response :success
    end

    should 'new' do
      get :new
      assert_response :success
    end

    should 'display new headers' do
      get :new
      assert_title I18n.t( 'helpers.title.user.new' ), I18n.t( 'helpers.title.user.index' ) 
      assert_headers I18n.t( 'helpers.title.user.index' ), I18n.t( 'helpers.title.user.new' )
    end

    should 'display index headers' do
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.user.index' ) )
      assert_select "h1", I18n.t( 'helpers.title.user.index' )
    end

    should 'display headers on edit other user password page' do
      get :edit_password, :id => @other_user.to_param
      assert_title I18n.t( 'helpers.title.user.edit_password' ), @other_user.login,
        I18n.t( 'helpers.title.user.index' )
      assert_headers I18n.t( 'helpers.title.user.index' ), @other_user.login,
        I18n.t( 'helpers.title.user.edit_password' )
    end

  end

end

