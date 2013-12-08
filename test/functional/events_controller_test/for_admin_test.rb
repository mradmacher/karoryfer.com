require 'test_helper'

module EventsControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = EventsController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    def test_get_index_displays_drafts
      5.times{ Event.sham!( published: true ) }
      5.times { Event.sham!( published: false ) }
      get :drafts
      Event.unpublished.each do |p|
        assert_select "a", p.title
      end
    end

    def test_get_edit_redirects_to_artist_scope
      event = Event.sham!
      get :edit, :id => event.to_param
      assert_redirected_to edit_artist_event_url( event.artist, event )
    end

    def test_get_edit_succeeds
      event = Event.sham!
      get :edit, :artist_id => event.artist.to_param, :id => event.to_param
      assert_response :success
    end

    def test_get_edit_displays_headers
      event = Event.sham!
      get :edit, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.event.edit' ), event.artist.name )
      assert_select "h1", event.artist.name
      assert_select "h2", I18n.t( 'helpers.title.event.index' )
      assert_select "h3", I18n.t( 'helpers.title.event.edit' )
    end

    def test_get_edit_displays_form
      event = Event.sham!
      get :edit, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.event.artist_id' )
        assert_select 'select[name=?]', 'event[artist_id]' do
          Artist.all.each do |g|
            if g == event.artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            else
              assert_select 'option[value=?]', g.id, g.name
            end
          end
        end
        assert_select 'label', I18n.t( 'helpers.label.event.title' )
        assert_select 'input[type=text][name=?][value=?]', 'event[title]', event.title
        assert_select 'label', I18n.t( 'helpers.label.event.published' )
        assert_select 'label', I18n.t( 'helpers.label.event.poster_url' )
        assert_select 'input[type=text][name=?]', 'event[poster_url]'
        unless event.poster_url.nil?
          assert_select 'input[type=text][name=?][value=?]', 'event[poster_url]', event.poster_url
        end
        assert_select 'label', I18n.t( 'helpers.label.event.body' )
        assert_select 'textarea[name=?]', 'event[body]',
          :text => event.body
      end
    end

    def test_get_edit_display_actions
      event = Event.sham!
      get :edit, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select 'a[href=?]', event_path( event ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.event.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.event.index' )
      assert_select "h2", I18n.t( 'helpers.title.event.new' )
    end

    def test_get_new_displays_form
      get :new
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.event.artist_id' )
        assert_select 'select[name=?]', 'event[artist_id]' do
          Artist.all.each do |g|
            assert_select 'option[value=?]', g.id, g.name
          end
        end
        assert_select 'label', I18n.t( 'helpers.label.event.title' )
        assert_select 'input[type=text][name=?]', 'event[title]'
        assert_select 'label', I18n.t( 'helpers.label.event.published' )
        assert_select 'label', I18n.t( 'helpers.label.event.poster_url' )
        assert_select 'input[type=text][name=?]', 'event[poster_url]'
        assert_select 'label', I18n.t( 'helpers.label.event.body' )
        assert_select 'textarea[name=?]', 'event[body]'
      end
    end

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', events_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_in_artist_scope_assigns_to_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_equal artist, assigns( :event ).artist
    end

    def test_get_new_in_artist_scope_displays_headers_with_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.event.new' ), artist.name )
      assert_select "h1", I18n.t( 'helpers.title.event.index' )
      assert_select "h2", I18n.t( 'helpers.title.event.new' )
    end

    def test_get_new_in_artist_scope_selects_artist_on_form
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select 'form' do
        assert_select 'select[name=?]', 'event[artist_id]' do
          Artist.all.each do |g|
            if g == artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            end
          end
        end
      end
    end

    def test_post_create_creates_event
      event = Event.sham!( :build )
      events_count = Event.count
      post :create, :event => event.attributes
      assert_equal events_count + 1, Event.count
      assert_redirected_to artist_event_url( event.artist, assigns( :event ) )
    end

    def test_put_update_updates_event
      event = Event.sham!
      title  = Faker::Name.name
      put :update, :id => event.to_param, :event => { title: title }
      event = event.reload
      assert_equal title, event.title
      assert_redirected_to artist_event_path( event.artist, event )
    end

    def test_delete_destroy_removes_event
      event = Event.sham!
      events_count = Event.count
      delete :destroy, :id => event.to_param
      assert_equal events_count - 1, Event.count
      refute Event.where(id: event.id).exists?
      assert_redirected_to artist_events_path( event.artist )
    end

    def test_get_index_displays_actions
      get :index
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
    end

    def test_get_show_displays_actions
      event = Event.sham!
      get :show, :artist_id => event.artist.to_param, :id => event.to_param
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
      assert_select 'a[href=?]', edit_event_path, I18n.t( 'helpers.action.event.edit' )
      assert_select 'a[href=?][data-method=delete]', event_path( event ), I18n.t( 'helpers.action.event.destroy' )
    end
  end
end

