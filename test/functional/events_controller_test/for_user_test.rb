require 'test_helper'

module EventsControllerTest
  class ForUserTest < ActionController::TestCase
    def setup
      @controller = EventsController.new
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
      event = Event.sham!
      get :show, :id => event.to_param
      assert_select 'a[href=?]', new_event_path, 0
      assert_select 'a[href=?]', edit_event_path, 0
      assert_select 'a[href=?][data-method=delete]', event_path( event ), 0
    end

    def test_get_index_is_denied_for_drafts
      assert_raises User::AccessDenied do
        get :drafts
      end
    end

    def test_get_show_is_denied_for_draft
      event = Event.sham!( published: false )
      assert_raises User::AccessDenied do
        get :show, :id => event.to_param
      end
    end

    def test_get_edit_is_denied
      assert_raises User::AccessDenied do
        get :edit, :id => Event.sham!.to_param
      end
    end

    def test_get_new_is_denied
      assert_raises User::AccessDenied do
        get :new
      end
    end

    def test_put_update_is_denied
      assert_raises User::AccessDenied do
        put :update, :id => Event.sham!.id, :event => {}
      end
    end

    def test_post_create_is_denied
      assert_raises User::AccessDenied do
        post :create, :event => {}
      end
    end

    def test_delete_destroy_is_denied
      assert_raises User::AccessDenied do
        delete :destroy, :id => Event.sham!.to_param
      end
    end
  end
end

