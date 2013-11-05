require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    10.times{ Event.sham! }
  end

  should 'get index' do
    get :index
    assert_response :success
    assert_template 'application'
    refute_nil assigns( :events )
  end

  should 'show headers on index page' do
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.event.index' ) )
    assert_select 'h1', I18n.t( 'helpers.title.event.index' )
  end

  should 'redirect show without artist' do
    event = Event.first
    get :show, :id => event.to_param
    assert_redirected_to artist_event_url( event.artist, event )
  end

  should 'get show ' do
    event = Event.first
    get :show, :artist_id => event.artist.to_param, :id => event.to_param
    assert_response :success
    assert_template 'application'
    assert_equal assigns( :event ), event 
  end

  should 'show headers on show page' do
    event = Event.first
    get :show, :artist_id => event.artist.to_param, :id => event.to_param
    assert_select "title", build_title( event.title, event.artist.name )
    assert_select 'h1', event.artist.name
    assert_select 'h2', I18n.t( 'helpers.title.event.index' )
    assert_select 'h3', event.title
  end

  should 'refute indexing unpublished events' do
    assert_raise( CanCan::AccessDenied ) do
      get :drafts
    end
  end

  should 'not show actions on index page' do
    get :index
    assert_select 'a[href=?]', new_post_path, 0
    assert_select 'a[href=?]', new_event_path, 0
  end

  should 'not show actions on show page' do
    event = Event.first
    get :show, :artist_id => event.artist.to_param, :id => event.to_param
    assert_select 'a[href=?]', new_event_path, 0
    assert_select 'a[href=?]', edit_event_path, 0
    assert_select 'a[href=?][data-method=delete]', event_path( event ), 0
  end

  should 'refute showing unpublished events' do
    event = Event.sham!( published: false )
    assert_raise( CanCan::AccessDenied ) do
      get :show, :id => event.to_param
    end
  end

  should 'refute edit' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :id => Event.first.to_param
    end
  end

  should 'refute new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end
  
  should 'refute update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => Event.first.id, :event => {}
    end
  end

  should 'refute create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :event => {}
    end
  end

  should 'refute destroy' do
    assert_raise( CanCan::AccessDenied ) do
      delete :destroy, :id => Event.first.to_param
    end
  end

  context 'for user' do
    setup do
      activate_authlogic
      @user = User.sham!
      UserSession.create @user
    end

    should 'not show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', new_event_path, 0
    end

    should 'not show actions on show page' do
      event = Event.first
      get :show, :id => event.to_param
      assert_select 'a[href=?]', new_event_path, 0
      assert_select 'a[href=?]', edit_event_path, 0
      assert_select 'a[href=?][data-method=delete]', event_path( event ), 0
    end

    should 'refute indexing unpublished events' do
      assert_raise( CanCan::AccessDenied ) do
        get :drafts
      end
    end

    should 'refute showing unpublished events' do
      event = Event.sham!( published: false )
      assert_raise( CanCan::AccessDenied ) do
        get :show, :id => event.to_param
      end
    end

    should 'refute edit' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => Event.first.to_param
      end
    end

    should 'refute new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end
    
    should 'refute update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Event.first.id, :event => {}
      end
    end

    should 'refute create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :event => {}
      end
    end

    should 'refute destroy' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => Event.first.to_param
      end
    end

  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    should 'index unpublished' do
      10.times { Event.sham!( published: false ) }
      get :drafts
      Event.unpublished.each do |p|
        assert_select "a", p.title
      end
    end

    should 'redirect edit without artist' do
      event = Event.first
      get :edit, :id => event.to_param
      assert_redirected_to edit_artist_event_url( event.artist, event )
    end

    context 'get edit' do
      setup do
        @event = Event.first
        get :edit, :artist_id => @event.artist.to_param, :id => @event.to_param
      end
      
      should 'be succes' do
        assert_response :success
        assert_template 'application'
        assert_equal @event, assigns( :event )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.event.edit' ), @event.artist.name )
        assert_select "h1", @event.artist.name
        assert_select "h2", I18n.t( 'helpers.title.event.index' )
        assert_select "h3", I18n.t( 'helpers.title.event.edit' )
      end

      should 'show form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.event.artist_id' )
          assert_select 'select[name=?]', 'event[artist_id]' do
            Artist.all.each do |g|
              if g == @event.artist
                assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
              else
                assert_select 'option[value=?]', g.id, g.name
              end
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.event.title' )
          assert_select 'input[type=text][name=?][value=?]', 'event[title]', @event.title 
          assert_select 'label', I18n.t( 'helpers.label.event.published' )
          assert_select 'label', I18n.t( 'helpers.label.event.poster_url' )
          assert_select 'input[type=text][name=?]', 'event[poster_url]'
          unless @event.poster_url.nil?
            assert_select 'input[type=text][name=?][value=?]', 'event[poster_url]', @event.poster_url 
          end
          assert_select 'label', I18n.t( 'helpers.label.event.body' )
          assert_select 'textarea[name=?]', 'event[body]', 
            :text => @event.body
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', event_path( @event ), I18n.t( 'helpers.action.cancel_edit' )
      end

    end

    context 'get new' do
      setup do
        get :new
      end

      should 'be success' do
        assert_response :success
        assert_template 'application'
        refute_nil assigns( :event )
        assert assigns( :event ).new_record?
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.event.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.event.index' )
        assert_select "h2", I18n.t( 'helpers.title.event.new' )
      end

      should 'show form' do
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

      should 'show actions' do
        assert_select 'a[href=?]', events_path, I18n.t( 'helpers.action.cancel_new' )
      end

    end

    context 'get new in artist scope' do
      setup do
        @artist = Artist.sham!
        get :new, :artist_id => @artist.to_param
      end

      should 'assign in to event' do
        assert_equal @artist, assigns( :event ).artist
      end

      should 'show headers with artist' do
        assert_select "title", build_title( I18n.t( 'helpers.title.event.new' ), @artist.name )
        assert_select "h1", I18n.t( 'helpers.title.event.index' )
        assert_select "h2", I18n.t( 'helpers.title.event.new' )
      end

      should 'select artist on form' do
        assert_select 'form' do
          assert_select 'select[name=?]', 'event[artist_id]' do
            Artist.all.each do |g|
              if g == @artist 
                assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
              end
            end
          end
        end
      end
    end

    should 'create' do
      attributes = Event.sham!( :build ).attributes
      attributes.delete( :id )
      attributes.delete( :created_at )
      attributes.delete( :updated_at )
      assert_difference 'Event.count' do
        post :create, :event => attributes
      end
      assert_not_nil assigns( :event )
      assert_redirected_to artist_event_url( assigns( :event ).artist, assigns( :event ) )
    end

    should 'update' do
      event = Event.first
      title  = Faker::Name.name
      assert_no_difference 'Event.count' do
        put :update, :id => event.to_param, :event => { title: title }
      end
      event = event.reload
      assert_equal title, event.title
      assert_redirected_to artist_event_path( event.artist, event )
    end

    should 'destroy' do
      event = Event.first
      assert_difference 'Event.count', -1 do
        delete :destroy, :id => event.to_param
      end
      assert_redirected_to artist_events_path( event.artist )
    end

    should 'show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
    end

    should 'show actions on show page' do
      p = Event.first
      get :show, :artist_id => p.artist.to_param, :id => p.to_param
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
      assert_select 'a[href=?]', edit_event_path, I18n.t( 'helpers.action.event.edit' )
      assert_select 'a[href=?][data-method=delete]', event_path( p ), I18n.t( 'helpers.action.event.destroy' )
    end
  end

end


