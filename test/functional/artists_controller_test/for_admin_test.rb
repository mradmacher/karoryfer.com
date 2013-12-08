require 'test_helper'

module ArtistsControllerTest
  class ForAdminTest < ActionController::TestCase
    def setup
      @controller = ArtistsController.new
      activate_authlogic
      @user = User.sham! :admin
      UserSession.create @user
    end

    def test_get_new_succeeds
      get :new
      assert_response :success
    end

    def test_get_new_displays_headers
      get :new
      assert_select "title", build_title( I18n.t( 'helpers.title.artist.new' ) )
      assert_select "h1", I18n.t( 'helpers.title.artist.new' )
    end

    def test_get_new_displays_actions
      get :new
      assert_select 'a[href=?]', artists_path, I18n.t( 'helpers.action.cancel_new' )
    end

    def test_get_new_displays_form
      get :new
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'helpers.label.artist.name' )
        assert_select 'input[type=text][name=?]', 'artist[name]'
        assert_select 'label', I18n.t( 'helpers.label.artist.reference' )
        assert_select 'input[type=text][name=?]', 'artist[reference]'
        assert_select 'label', I18n.t( 'helpers.label.artist.image' )
        assert_select 'input[type=file][name=?]', 'artist[image]'
        assert_select 'label', I18n.t( 'helpers.label.artist.summary' )
        assert_select 'input[type=text][name=?]', 'artist[summary]'
        assert_select 'label', I18n.t( 'helpers.label.artist.description' )
        assert_select 'textarea[name=?]', 'artist[description]'
        assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
      end
    end

    def test_get_edit_succeeds
      get :edit, :id => Artist.sham!.to_param
      assert_template 'current_artist'
      assert_response :success
    end

    def test_get_edit_displays_headers
      artist = Artist.sham!
      get :edit, :id => artist.to_param
      assert_select "title", build_title( I18n.t( 'helpers.title.artist.edit' ), artist.name )
      assert_select 'h1', artist.name
      assert_select 'h2', I18n.t( 'helpers.title.artist.edit' )
    end

    def test_get_edit_displays_actions
      artist = Artist.sham!
      get :edit, :id => artist.to_param
      assert_select 'a[href=?]', artist_path( artist ), I18n.t( 'helpers.action.cancel_edit' )
    end

    def test_get_edit_displays_form
      artist = Artist.sham!
      get :edit, :id => artist.to_param
      assert_select 'form[enctype="multipart/form-data"]' do
        assert_select 'label', I18n.t( 'helpers.label.artist.name' )
        assert_select 'input[type=text][name=?][value=?]', 'artist[name]', artist.name
        assert_select 'label', I18n.t( 'helpers.label.artist.reference' )
        assert_select 'input[type=text][name=?][value=?]', 'artist[reference]', artist.reference
        assert_select 'label', I18n.t( 'helpers.label.artist.image' )
        assert_select 'input[type=file][name=?]', 'artist[image]'
        assert_select 'label', I18n.t( 'helpers.label.artist.summary' )
        assert_select 'input[type=text][name=?]', 'artist[summary]', artist.summary
        assert_select 'label', I18n.t( 'helpers.label.artist.description' )
        assert_select 'textarea[name=?]', 'artist[description]', artist.description
        assert_select 'input[type=submit][value=?]', I18n.t( 'helpers.action.save' )
      end
    end

    def test_post_create_creates_artist
      attributes = Artist.sham!( :build ).attributes
      artists_count = Artist.count
      post :create, :artist => attributes
      assert_equal artists_count + 1, Artist.count
      assert_redirected_to artist_url( assigns( :artist ) )
    end

    def test_put_update_updates_artist
      artist = Artist.sham!
      name = Faker::Name.name
      put :update, :id => artist.to_param, :artist => {name: name}
      artist.reload
      assert_equal name, artist.name
      assert_redirected_to artist_url( assigns( :artist ) )
    end

    def test_get_index_displays_actions
      get :index
      assert_select 'a[href=?]', new_artist_path, I18n.t( 'helpers.action.artist.new' )
    end

    def test_get_show_displays_actions
      artist = Artist.sham!
      get :show, :id => artist.to_param
      assert_select 'a[href=?]', edit_artist_path, I18n.t( 'helpers.action.artist.edit' )
      assert_select 'a[href=?]', new_post_path, I18n.t( 'helpers.action.post.new' )
      #assert_select 'a[href=?][data-method=delete]', artist_path( artist ), I18n.t( 'helpers.action.artist.destroy' )
      assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
    end
  end
end


