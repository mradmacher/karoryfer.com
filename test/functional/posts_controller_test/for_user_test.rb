require 'test_helper'

module PostsControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = PostsController.new
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', new_event_path, 0
    end

    def test_get_show_does_not_display_actions
      post = Post.sham!
      get :show, :id => post.to_param
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', edit_post_path, 0
      assert_select 'a[href=?][data-method=delete]', post_path( post ), 0
    end

    def test_get_drafts_is_denied
      assert_raises User::AccessDenied do
        get :drafts
      end
    end

    def test_get_show_unpublished_is_denied
      post = Post.sham!( published: false )
      assert_raises User::AccessDenied do
        get :show, :id => post.to_param
      end
    end

    def test_get_edit_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => Post.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => Post.sham!.id, :post => {}
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :post => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => Post.sham!.to_param
      end
    end
  end
end

