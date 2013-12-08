require 'test_helper'

module PostsControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = PostsController.new
    end

    def test_get_index_succeeds
      10.times { Post.sham! }
      get :index
      assert_response :success
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.post.index' ) )
      assert_select 'h1', I18n.t( 'helpers.title.post.index' )
    end

    def test_get_show_redirects_to_artist_scope
      post = Post.sham!
      get :show, :id => post.to_param
      assert_redirected_to artist_post_url( post.artist, post )
    end

    def test_get_show_succeeds
      post = Post.sham!
      get :show, :artist_id => post.artist.to_param, :id => post.to_param
      assert_response :success
    end

    def test_get_show_displays_headers
      post = Post.sham!
      get :show, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select "title", build_title( post.title, post.artist.name )
      assert_select 'h1', post.artist.name
      assert_select 'h2', I18n.t( 'helpers.title.post.index' )
      assert_select 'h3', post.title
    end

    def test_get_drafts_is_denied
      assert_raises CanCan::AccessDenied do
        get :drafts
      end
    end

    def test_get_index_does_not_show_actions
      get :index
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', new_event_path, 0
    end

    def test_get_show_does_not_display_actions
      post = Post.sham!
      get :show, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', edit_post_path, 0
      assert_select 'a[href=?][data-method=delete]', post_path( post ), 0
    end

    def test_get_show_unpublished_is_denied
      post = Post.sham!( published: false )
      assert_raises CanCan::AccessDenied do
        get :show, :id => post.to_param
      end
    end

    def test_get_edit_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit, :id => Post.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises CanCan::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises CanCan::AccessDenied do
        put :update, :id => Post.sham!.id, :post => {}
      end
    end

    def test_post_create_is_denied
      assert_raises CanCan::AccessDenied do
        post :create, :post => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises CanCan::AccessDenied do
        delete :destroy, :id => Post.sham!.to_param
      end
    end
  end
end

