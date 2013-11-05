require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup do
    10.times{ Video.sham! }
  end

  should 'get index' do
    get :index
    assert_response :success
    assert_template 'application'
    refute_nil assigns( :videos )
  end

  should 'show headers on index page' do
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.video.index' ) )
    assert_select 'h1', I18n.t( 'helpers.title.video.index' )
  end

  should 'redirect show without artist' do
    video = Video.first
    get :show, :id => video.to_param
    assert_redirected_to artist_video_url( video.artist, video )
  end

  should 'get show ' do
    video = Video.first
    get :show, :artist_id => video.artist.to_param, :id => video.to_param
    assert_response :success
    assert_template 'application'
    assert_equal assigns( :video ), video 
  end

  should 'show headers on show page' do
    video = Video.first
    get :show, :artist_id => video.artist.to_param, :id => video.to_param
    assert_select "title", build_title( video.title, video.artist.name )
    assert_select 'h1', video.artist.name
    assert_select 'h2', I18n.t( 'helpers.title.video.index' )
    assert_select 'h3', video.title
  end

  should 'not show actions on index page' do
    get :index
    assert_select 'a[href=?]', new_video_path, 0
  end

  should 'not show actions on show page' do
    video = Video.first
    get :show, :artist_id => video.artist.to_param, :id => video.to_param
    assert_select 'a[href=?]', new_video_path, 0
    assert_select 'a[href=?]', edit_video_path, 0
    assert_select 'a[href=?][data-method=delete]', video_path( video ), 0
  end

  should 'refute edit' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :id => Video.first.to_param
    end
  end

  should 'refute new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end
  
  should 'refute update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => Video.first.id, :video => {}
    end
  end

  should 'refute create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :video => {}
    end
  end

  should 'refute destroy' do
    assert_raise( CanCan::AccessDenied ) do
      delete :destroy, :id => Video.first.to_param
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
      assert_select 'a[href=?]', new_video_path, 0
    end

    should 'not show actions on show page' do
      video = Video.first
      get :show, :id => video.to_param
      assert_select 'a[href=?]', new_video_path, 0
      assert_select 'a[href=?]', edit_video_path, 0
      assert_select 'a[href=?][data-method=delete]', video_path( video ), 0
    end

    should 'refute edit' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => Video.first.to_param
      end
    end

    should 'refute new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end
    
    should 'refute update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Video.first.id, :video => {}
      end
    end

    should 'refute create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :video => {}
      end
    end

    should 'refute destroy' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => Video.first.to_param
      end
    end
  end

  context 'for admin' do
    setup do
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    should 'redirect edit without artist' do
      video = Video.first
      get :edit, :id => video.to_param
      assert_redirected_to edit_artist_video_url( video.artist, video )
    end

    context 'get edit' do
      setup do
        @video = Video.first
        get :edit, :artist_id => @video.artist.to_param, :id => @video.to_param
      end
      
      should 'be succes' do
        assert_response :success
        assert_template 'application'
        assert_equal @video, assigns( :video )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.video.edit' ), @video.artist.name )
        assert_select "h1", @video.artist.name
        assert_select "h2", I18n.t( 'helpers.title.video.index' )
        assert_select "h3", I18n.t( 'helpers.title.video.edit' )
      end

      should 'show form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.video.artist_id' )
          assert_select 'select[name=?]', 'video[artist_id]' do
            Artist.all.each do |g|
              if g == @video.artist
                assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
              else
                assert_select 'option[value=?]', g.id, g.name
              end
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.video.title' )
          assert_select 'input[type=text][name=?][value=?]', 'video[title]', @video.title 
          assert_select 'label', I18n.t( 'helpers.label.video.url' )
          assert_select 'input[type=text][name=?][value=?]', 'video[url]', @video.url 
          assert_select 'label', I18n.t( 'helpers.label.video.body' )
          assert_select 'textarea[name=?]', 'video[body]', 
            :text => @video.body
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', video_path( @video ), I18n.t( 'helpers.action.cancel_edit' )
      end

    end

    context 'get new' do
      setup do
        get :new
      end

      should 'be success' do
        assert_response :success
        assert_template 'application'
        refute_nil assigns( :video )
        assert assigns( :video ).new_record?
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.video.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.video.index' )
        assert_select "h2", I18n.t( 'helpers.title.video.new' )
      end

      should 'show form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.video.artist_id' )
          assert_select 'select[name=?]', 'video[artist_id]' do
            Artist.all.each do |g|
              assert_select 'option[value=?]', g.id, g.name
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.video.title' )
          assert_select 'input[type=text][name=?]', 'video[title]'
          assert_select 'label', I18n.t( 'helpers.label.video.url' )
          assert_select 'input[type=text][name=?]', 'video[url]'
          assert_select 'label', I18n.t( 'helpers.label.video.body' )
          assert_select 'textarea[name=?]', 'video[body]'
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', videos_path, I18n.t( 'helpers.action.cancel_new' )
      end

    end

    context 'get new in artist scope' do
      setup do
        @artist = Artist.sham!
        get :new, :artist_id => @artist.to_param
      end

      should 'assign in to video' do
        assert_equal @artist, assigns( :video ).artist
      end

      should 'show headers with artist' do
        assert_select "title", build_title( I18n.t( 'helpers.title.video.new' ), @artist.name )
        assert_select "h1", I18n.t( 'helpers.title.video.index' )
        assert_select "h2", I18n.t( 'helpers.title.video.new' )
      end

      should 'select artist on form' do
        assert_select 'form' do
          assert_select 'select[name=?]', 'video[artist_id]' do
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
      attributes = Video.sham!( :build ).attributes
      attributes.delete( :created_at )
      attributes.delete( :updated_at )
      assert_difference 'Video.count' do
        post :create, :video => attributes
      end
      assert_not_nil assigns( :video )
      assert_redirected_to artist_video_url( assigns( :video ).artist, assigns( :video ) )
    end

    should 'update' do
      video = Video.sham!
      title = Faker::Name.name
      assert_no_difference 'Video.count' do
        put :update, :id => video.to_param, :video => {title: title}
      end
      video = Video.find( video.id )
      assert_equal title, video.title
      assert_redirected_to artist_video_path( video.artist, video )
    end

    should 'destroy' do
      video = Video.first
      assert_difference 'Video.count', -1 do
        delete :destroy, :id => video.to_param
      end
      assert_redirected_to artist_videos_path( video.artist )
    end

    should 'show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_video_path, I18n.t( 'helpers.action.video.new' )
    end

    should 'show actions on show page' do
      p = Video.first
      get :show, :artist_id => p.artist.to_param, :id => p.to_param
      assert_select 'a[href=?]', new_video_path, I18n.t( 'helpers.action.video.new' )
      assert_select 'a[href=?]', edit_video_path, I18n.t( 'helpers.action.video.edit' )
      assert_select 'a[href=?][data-method=delete]', video_path( p ), I18n.t( 'helpers.action.video.destroy' )
    end
  end

end

