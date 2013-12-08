require 'test_helper'

module VideosControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = VideosController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    def test_get_edit_redirects_to_artist_scope
      video = Video.sham!
      get :edit, :id => video.to_param
      assert_redirected_to edit_artist_video_url( video.artist, video )
    end

    def test_get_edit_succeeds
      video = Video.sham!
      get :edit, :artist_id => video.artist.to_param, :id => video.to_param
      assert_response :success
    end

    def test_get_edit_displays_headers
      video = Video.sham!
      get :edit, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.video.edit' ), video.artist.name )
      assert_select "h1", video.artist.name
      assert_select "h2", I18n.t( 'helpers.title.video.index' )
      assert_select "h3", I18n.t( 'helpers.title.video.edit' )
    end

    def test_get_edit_displays_form
      video = Video.sham!
      get :edit, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select 'form' do
        assert_select 'label', I18n.t( 'helpers.label.video.artist_id' )
        assert_select 'select[name=?]', 'video[artist_id]' do
          Artist.all.each do |g|
            if g == video.artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            else
              assert_select 'option[value=?]', g.id, g.name
            end
          end
        end
        assert_select 'label', I18n.t( 'helpers.label.video.title' )
        assert_select 'input[type=text][name=?][value=?]', 'video[title]', video.title
        assert_select 'label', I18n.t( 'helpers.label.video.url' )
        assert_select 'input[type=text][name=?][value=?]', 'video[url]', video.url
        assert_select 'label', I18n.t( 'helpers.label.video.body' )
        assert_select 'textarea[name=?]', 'video[body]', :text => video.body
      end
    end

    def test_get_edit_displays_actions
      video = Video.sham!
      get :edit, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select 'a[href=?]', video_path( video ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.video.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.video.index' )
      assert_select "h2", I18n.t( 'helpers.title.video.new' )
    end

    def test_get_new_displays_form
      get :new
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

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', videos_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_in_artist_scope_assigns_video_to_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_equal artist, assigns( :video ).artist
    end

    def test_get_new_in_artist_scope_displays_headers_with_artist
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.video.new' ), artist.name )
      assert_select "h1", I18n.t( 'helpers.title.video.index' )
      assert_select "h2", I18n.t( 'helpers.title.video.new' )
    end

    def test_get_new_in_artist_scope_selects_artist_on_form
      artist = Artist.sham!
      get :new, :artist_id => artist.to_param
      assert_select 'form' do
        assert_select 'select[name=?]', 'video[artist_id]' do
          Artist.all.each do |g|
            if g == artist
              assert_select 'option[value=?][selected=?]', g.id, 'selected',  g.name
            end
          end
        end
      end
    end

    def test_post_create_succeeds
      video = Video.sham!( :build )
      videos_count = Video.count
      post :create, :video => video.attributes
      assert_equal videos_count + 1, Video.count
      assert_redirected_to artist_video_url( video.artist, assigns( :video ) )
    end

    def test_put_update_succeeds
      video = Video.sham!
      title = Faker::Name.name
      put :update, :id => video.to_param, :video => {title: title}
      video.reload
      assert_equal title, video.title
      assert_redirected_to artist_video_path( video.artist, video )
    end

    def test_delete_destroy_succeeds
      video = Video.sham!
      videos_count = Video.count
      delete :destroy, :id => video.to_param
      assert_equal videos_count - 1, Video.count
      assert_redirected_to artist_videos_path( video.artist )
    end

    def test_get_index_displays_actions
      get :index
      assert_select 'a[href=?]', new_video_path, I18n.t( 'helpers.action.video.new' )
    end

    def test_get_show_displays_actions
      video = Video.sham!
      get :show, :artist_id => video.artist.to_param, :id => video.to_param
      assert_select 'a[href=?]', new_video_path, I18n.t( 'helpers.action.video.new' )
      assert_select 'a[href=?]', edit_video_path, I18n.t( 'helpers.action.video.edit' )
      assert_select 'a[href=?][data-method=delete]', video_path( video ), I18n.t( 'helpers.action.video.destroy' )
    end
  end
end

