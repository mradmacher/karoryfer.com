require 'test_helper'
class PostsControllerTest < ActionController::TestCase
  setup do
    10.times{ Post.sham! }
  end

  should 'get index' do
    get :index
    assert_response :success
    assert_template 'application'
    refute_nil assigns( :posts )
  end

  should 'show headers on index page' do
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.post.index' ) )
    assert_select 'h1', I18n.t( 'helpers.title.post.index' )
  end

  should 'redirect show without artist' do
    post = Post.first
    get :show, :id => post.to_param
    assert_redirected_to artist_post_url( post.artist, post )
  end

  should 'get show ' do
    post = Post.first
    get :show, :artist_id => post.artist.to_param, :id => post.to_param
    assert_response :success
    assert_template 'application'
    assert_equal assigns( :post ), post 
  end

  should 'show headers on show page' do
    post = Post.first
    get :show, :artist_id => post.artist.to_param, :id => post.to_param
    assert_select "title", build_title( post.title, post.artist.name )
    assert_select 'h1', post.artist.name
    assert_select 'h2', I18n.t( 'helpers.title.post.index' )
    assert_select 'h3', post.title
  end

  should 'refute indexing unpublished posts' do
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
    post = Post.first
    get :show, :artist_id => post.artist.to_param, :id => post.to_param
    assert_select 'a[href=?]', new_post_path, 0
    assert_select 'a[href=?]', edit_post_path, 0
    assert_select 'a[href=?][data-method=delete]', post_path( post ), 0
  end

  should 'refute showing unpublished posts' do
    post = Post.sham!( published: false )
    assert_raise( CanCan::AccessDenied ) do
      get :show, :id => post.to_param
    end
  end

  should 'refute edit' do
    assert_raise( CanCan::AccessDenied ) do
      get :edit, :id => Post.first.to_param
    end
  end

  should 'refute new' do
    assert_raise( CanCan::AccessDenied ) do
      get :new
    end
  end
  
  should 'refute update' do
    assert_raise( CanCan::AccessDenied ) do
      put :update, :id => Post.first.id, :post => {}
    end
  end

  should 'refute create' do
    assert_raise( CanCan::AccessDenied ) do
      post :create, :post => {}
    end
  end

  should 'refute destroy' do
    assert_raise( CanCan::AccessDenied ) do
      delete :destroy, :id => Post.first.to_param
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
      post = Post.first
      get :show, :id => post.to_param
      assert_select 'a[href=?]', new_post_path, 0
      assert_select 'a[href=?]', edit_post_path, 0
      assert_select 'a[href=?][data-method=delete]', post_path( post ), 0
    end

    should 'refute indexing unpublished posts' do
      assert_raise( CanCan::AccessDenied ) do
        get :drafts
      end
    end

    should 'refute showing unpublished posts' do
      post = Post.sham!( published: false )
      assert_raise( CanCan::AccessDenied ) do
        get :show, :id => post.to_param
      end
    end

    should 'refute edit' do
      assert_raise( CanCan::AccessDenied ) do
        get :edit, :id => Post.first.to_param
      end
    end

    should 'refute new' do
      assert_raise( CanCan::AccessDenied ) do
        get :new
      end
    end
    
    should 'refute update' do
      assert_raise( CanCan::AccessDenied ) do
        put :update, :id => Post.first.id, :post => {}
      end
    end

    should 'refute create' do
      assert_raise( CanCan::AccessDenied ) do
        post :create, :post => {}
      end
    end

    should 'refute destroy' do
      assert_raise( CanCan::AccessDenied ) do
        delete :destroy, :id => Post.first.to_param
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
      10.times { Post.sham!( published: false ) }
      get :drafts
      Post.unpublished.each do |p|
        assert_select "a", p.title
      end
    end

    should 'redirect edit without artist' do
      post = Post.first
      get :edit, :id => post.to_param
      assert_redirected_to edit_artist_post_url( post.artist, post )
    end

    context 'get edit' do
      setup do
        @post = Post.first
        get :edit, :artist_id => @post.artist.to_param, :id => @post.to_param
      end
      
      should 'be succes' do
        assert_response :success
        assert_template 'application'
        assert_equal @post, assigns( :post )
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.post.edit' ), @post.artist.name )
        assert_select "h1", @post.artist.name
        assert_select "h2", I18n.t( 'helpers.title.post.index' )
        assert_select "h3", I18n.t( 'helpers.title.post.edit' )
      end

      should 'show form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.post.artist_id' )
          assert_select 'select[name=?]', 'post[artist_id]' do
            Artist.all.each do |g|
              if g == @post.artist
                assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
              else
                assert_select 'option[value=?]', g.id, g.name
              end
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.post.title' )
          assert_select 'input[type=text][name=?][value=?]', 'post[title]', @post.title 
          assert_select 'label', I18n.t( 'helpers.label.post.published' )
          assert_select 'label', I18n.t( 'helpers.label.post.poster_url' )
          assert_select 'input[type=text][name=?]', 'post[poster_url]'
          unless @post.poster_url.nil?
            assert_select 'input[type=text][name=?][value=?]', 'post[poster_url]', @post.poster_url 
          end
          assert_select 'label', I18n.t( 'helpers.label.post.body' )
          assert_select 'textarea[name=?]', 'post[body]', 
            :text => @post.body
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', post_path( @post ), I18n.t( 'helpers.action.cancel_edit' )
      end

    end

    context 'get new' do
      setup do
        get :new
      end

      should 'be success' do
        assert_response :success
        assert_template 'application'
        refute_nil assigns( :post )
        assert assigns( :post ).new_record?
      end

      should 'show headers' do
        assert_select "title", build_title( I18n.t( 'helpers.title.post.new' ) )
        assert_select "h1", I18n.t( 'helpers.title.post.index' )
        assert_select "h2", I18n.t( 'helpers.title.post.new' )
      end

      should 'show form' do
        assert_select 'form' do
          assert_select 'label', I18n.t( 'helpers.label.post.artist_id' )
          assert_select 'select[name=?]', 'post[artist_id]' do
            Artist.all.each do |g|
              assert_select 'option[value=?]', g.id, g.name
            end
          end
          assert_select 'label', I18n.t( 'helpers.label.post.title' )
          assert_select 'input[type=text][name=?]', 'post[title]'
          assert_select 'label', I18n.t( 'helpers.label.post.published' )
          assert_select 'label', I18n.t( 'helpers.label.post.poster_url' )
          assert_select 'input[type=text][name=?]', 'post[poster_url]'
          assert_select 'label', I18n.t( 'helpers.label.post.body' )
          assert_select 'textarea[name=?]', 'post[body]'
        end
      end

      should 'show actions' do
        assert_select 'a[href=?]', posts_path, I18n.t( 'helpers.action.cancel_new' )
      end

    end

    context 'get new in artist scope' do
      setup do
        @artist = Artist.sham!
        get :new, :artist_id => @artist.to_param
      end

      should 'assign in to post' do
        assert_equal @artist, assigns( :post ).artist
      end

      should 'show headers with artist' do
        assert_select "title", build_title( I18n.t( 'helpers.title.post.new' ), @artist.name )
        assert_select "h1", I18n.t( 'helpers.title.post.index' )
        assert_select "h2", I18n.t( 'helpers.title.post.new' )
      end

      should 'select artist on form' do
        assert_select 'form' do
          assert_select 'select[name=?]', 'post[artist_id]' do
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
      attributes = Post.sham!( :build ).attributes
      attributes.delete( :id )
      attributes.delete( :created_at )
      attributes.delete( :updated_at )
      assert_difference 'Post.count' do
        post :create, :post => attributes
      end
      assert_not_nil assigns( :post )
      assert_redirected_to artist_post_url( assigns( :post ).artist, assigns( :post ) )
    end

    should 'update' do
      post = Post.first
      title  = Faker::Name.name
      assert_no_difference 'Post.count' do
        put :update, :id => post.to_param, :post => { title: title }
      end
      post = post.reload
      assert_equal title, post.title
      assert_redirected_to artist_post_path( post.artist, post )
    end

    should 'destroy' do
      post = Post.first
      assert_difference 'Post.count', -1 do
        delete :destroy, :id => post.to_param
      end
      assert_redirected_to artist_posts_path( post.artist )
    end

    should 'show actions on index page' do
      get :index
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
    end

    should 'show actions on show page' do
      p = Post.first
      get :show, :artist_id => p.artist.to_param, :id => p.to_param
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', edit_post_path, I18n.t( 'helpers.action.post.edit' )
      assert_select 'a[href=?][data-method=delete]', post_path( p ), I18n.t( 'helpers.action.post.destroy' )
    end
  end
end

