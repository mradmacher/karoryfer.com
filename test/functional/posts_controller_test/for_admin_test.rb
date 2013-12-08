require 'test_helper'

module PostsControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = PostsController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    def test_get_drafts_secceeds
      10.times { Post.sham!( published: false ) }
      get :drafts
      Post.unpublished.each do |p|
        assert_select "a", p.title
      end
    end

    def test_get_edit_redirects_to_artist_scope
      post = Post.sham!
      get :edit, :id => post.to_param
      assert_redirected_to edit_artist_post_url( post.artist, post )
    end

    def test_get_edit_succeeds
      post = Post.sham!
      get :edit, :artist_id => post.artist.to_param, :id => post.to_param
      assert_response :success
    end

    def test_get_edit_displays_headers
      post = Post.sham!
      get :edit, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.post.edit' ), post.artist.name )
      assert_select "h1", post.artist.name
      assert_select "h2", I18n.t( 'helpers.title.post.index' )
      assert_select "h3", I18n.t( 'helpers.title.post.edit' )
    end

    def test_get_edit_displays_form
      post = Post.sham!
      get :edit, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.post.artist_id' )
        assert_select 'select[name=?]', 'post[artist_id]' do
          Artist.all.each do |g|
            if g == post.artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            else
              assert_select 'option[value=?]', g.id, g.name
            end
          end
        end
        assert_select 'label', I18n.t( 'helpers.label.post.title' )
        assert_select 'input[type=text][name=?][value=?]', 'post[title]', post.title
        assert_select 'label', I18n.t( 'helpers.label.post.published' )
        assert_select 'label', I18n.t( 'helpers.label.post.poster_url' )
        assert_select 'input[type=text][name=?]', 'post[poster_url]'
        unless post.poster_url.nil?
          assert_select 'input[type=text][name=?][value=?]', 'post[poster_url]', post.poster_url
        end
        assert_select 'label', I18n.t( 'helpers.label.post.body' )
        assert_select 'textarea[name=?]', 'post[body]', :text => post.body
      end
    end

    def test_get_edit_displays_actions
      post = Post.sham!
      get :edit, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select 'a[href=?]', post_path( post ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.post.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.post.index' )
      assert_select "h2", I18n.t( 'helpers.title.post.new' )
    end

    def test_get_new_displays_form
      get :new
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

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', posts_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_in_artist_scope_assigns_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_equal artist, assigns( :post ).artist
    end

    def test_get_new_in_artist_scope_displays_headers_with_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.post.new' ), artist.name )
      assert_select "h1", I18n.t( 'helpers.title.post.index' )
      assert_select "h2", I18n.t( 'helpers.title.post.new' )
    end

    def test_get_new_in_artist_scope_selects_artist_on_form
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select 'form' do
        assert_select 'select[name=?]', 'post[artist_id]' do
          Artist.all.each do |g|
            if g == artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            end
          end
        end
      end
    end

    def test_post_create_succeeds
      p = Post.sham!( :build )
      posts_count = Post.count
      post :create, :post => p.attributes
      assert_equal posts_count + 1, Post.count
      assert_redirected_to artist_post_url( p.artist, assigns( :post ) )
    end

    def test_put_update_succeeds
      post = Post.sham!
      title  = Faker::Name.name
      put :update, :id => post.to_param, :post => { title: title }
      post.reload
      assert_equal title, post.title
      assert_redirected_to artist_post_path( post.artist, post )
    end

    def test_delete_destroy_succeeds
      post = Post.sham!
      posts_count = Post.count
      delete :destroy, :id => post.to_param
      assert_equal posts_count - 1, Post.count
      assert_redirected_to artist_posts_path( post.artist )
    end

    def test_get_index_displays_actions
      get :index
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', new_event_path, I18n.t( 'helpers.action.event.new' )
    end

    def test_get_show_displays_actions
      post = Post.sham!
      get :show, :artist_id => post.artist.to_param, :id => post.to_param
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      assert_select 'a[href=?]', edit_post_path, I18n.t( 'helpers.action.post.edit' )
      assert_select 'a[href=?][data-method=delete]', post_path( post ), I18n.t( 'helpers.action.post.destroy' )
    end
  end
end

