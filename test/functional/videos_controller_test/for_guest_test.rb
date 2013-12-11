require 'test_helper'

module VideosControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = VideosController.new
    end

    def test_get_index_succeeds
      get :index
      assert_response :success
    end

    def test_get_show_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.video.index' ) )
      assert_select 'h1', I18n.t( 'helpers.title.video.index' )
    end

    def test_get_show_redirects_to_artist_scope
      video = Video.sham!
      get :show, :id => video.to_param
      assert_redirected_to artist_video_url( video.artist, video )
    end

    def test_get_show_succeeds
      video = Video.sham!
      get :show, :artist_id => video.artist.to_param, :id => video.to_param
      assert_response :success
    end

    def test_get_show_displays_headers
      video = Video.sham!
      get :show, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select "title", build_title( video.title, video.artist.name )
      assert_select 'h1', video.artist.name
      assert_select 'h2', I18n.t( 'helpers.title.video.index' )
      assert_select 'h3', video.title
    end

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_video_path, 0
    end

    def test_get_show_does_not_display_actions
      video = Video.sham!
      get :show, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select 'a[href=?]', new_video_path, 0
      assert_select 'a[href=?]', edit_video_path, 0
      assert_select 'a[href=?][data-method=delete]', video_path( video ), 0
    end

    def test_get_edit_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => Video.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => Video.sham!.id, :video => {}
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :video => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => Video.sham!.to_param
      end
    end
  end
end

