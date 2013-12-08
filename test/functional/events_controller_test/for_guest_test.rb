require 'test_helper'

module EventsControllerTest
  class ForGuestTest < ActionController::TestCase
    def setup
      @controller = EventsController.new
    end

    def test_get_index_succeeds
      10.times{ Event.sham! }
      get :index
      assert_response :success
    end

    def test_get_index_displays_headers
      get :index
      assert_select "title", build_title( I18n.t( 'helpers.title.event.index' ) )
      assert_select 'h1', I18n.t( 'helpers.title.event.index' )
    end

    def test_get_show_redirects_to_artists_scope
      event = Event.sham!
      get :show, :id => event.to_param
      assert_redirected_to artist_event_url( event.artist, event )
    end

    def test_get_show_succeeds
      event = Event.sham!
      get :show, :artist_id => event.artist.to_param, :id => event.to_param
      assert_response :success
    end

    def test_get_show_displays_headers
      event = Event.sham!
      get :show, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select "title", build_title( event.title, event.artist.name )
      assert_select 'h1', event.artist.name
      assert_select 'h2', I18n.t( 'helpers.title.event.index' )
      assert_select 'h3', event.title
    end

    def test_get_index_is_denied_for_drafts
      assert_raises CanCan::AccessDenied do
        get :drafts
      end
    end

    def test_get_index_does_not_display_actions
      get :index
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', new_event_path, 0
    end

    def test_get_show_does_not_display_actions
      event = Event.sham!
      get :show, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select 'a[href=?]', new_event_path, 0
      assert_select 'a[href=?]', edit_event_path, 0
      assert_select 'a[href=?][data-method=delete]', event_path( event ), 0
    end

    def test_get_show_is_denied_for_unpublished
      event = Event.sham!( published: false )
      assert_raises CanCan::AccessDenied do
        get :show, :id => event.to_param
      end
    end

    def test_get_edit_is_denied
      assert_raises CanCan::AccessDenied do
        get :edit, :id => Event.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises CanCan::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises CanCan::AccessDenied do
        put :update, :id => Event.sham!.id, :event => {}
      end
    end

    def test_post_create_is_denied
      assert_raises CanCan::AccessDenied do
        post :create, :event => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises CanCan::AccessDenied do
        delete :destroy, :id => Event.sham!.to_param
      end
    end
  end
end

