require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  def test_get_index_succeeds_for_guest
    get :index
    assert_response :success
  end

  def test_get_index_displays_headers_for_guest
    get :index
    assert_select "title", build_title( I18n.t( 'helpers.title.artist.index' ) )
    assert_select "h1", I18n.t( 'helpers.title.artist.index' )
  end

  def test_get_index_does_not_display_actions_for_guest
    get :index
    assert_select 'a[href=?]', new_artist_path, 0
  end

  def test_get_index_does_not_display_actions_for_user
    login( User.sham! )
    get :index
    assert_select 'a[href=?]', new_artist_path, 0
  end

  def test_get_index_displays_actions_for_admin
    login( User.sham!(:admin) )
    get :index
    assert_select 'a[href=?]', new_artist_path, I18n.t( 'helpers.action.artist.new' )
  end

  def test_get_show_succeeds
    get :show, :id => Artist.sham!.to_param
    assert_template 'current_artist'
    assert_response :success
  end

  def test_get_show_displays_headers
    artist = Artist.sham!
    get :show, :id => artist.to_param
    assert_select "title", build_title( artist.name )
    assert_select "h1", artist.name
  end

  def test_get_show_does_not_display_actions_for_guest
    artist = Artist.sham!
    get :show, :id => artist.to_param
    assert_select 'a[href=?]', edit_artist_path, 0
    assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
  end

  def test_get_show_does_not_display_actions_for_user
    login( User.sham! )
    artist = Artist.sham!
    get :show, :id => artist.to_param
    assert_select 'a[href=?]', edit_artist_path, 0
    assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
  end

  def test_get_show_displays_edit_action_for_artist_user
    membership = Membership.sham!
    login( membership.user )
    get :show, :id => membership.artist.to_param
    assert_select 'a[href=?]', edit_artist_path, I18n.t( 'helpers.action.artist.edit' )
    assert_select 'a[href=?][data-method=delete]', artist_path( membership.artist ), 0
  end

  def test_get_new_is_denied_for_guest
    assert_raises User::AccessDenied do
      get :new
    end
  end

  def test_get_new_is_denied_for_user
    login( User.sham! )
    assert_raises User::AccessDenied do
      get :new
    end
  end

  def test_get_new_is_denied_for_artist_user
    membership = Membership.sham!
    login( membership.user )
    assert_raises User::AccessDenied do
      get :new
    end
  end

  def test_get_new_succeeds_for_admin
    login( User.sham!(:admin) )
    get :new
    assert_response :success
  end

  def test_get_new_displays_headers_for_admin
    login( User.sham!(:admin) )
    get :new
    assert_select "title", build_title( I18n.t( 'helpers.title.artist.new' ) )
    assert_select "h1", I18n.t( 'helpers.title.artist.new' )
  end

  def test_get_new_displays_form_for_admin
    login( User.sham!(:admin) )
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

  def test_get_edit_is_denied_for_guest
    assert_raises User::AccessDenied do
      get :edit, :id => Artist.sham!.to_param
    end
  end

  def test_get_edit_is_denied_for_user
    login( User.sham! )
    assert_raises User::AccessDenied do
      get :edit, :id => Artist.sham!.to_param
    end
  end

  def test_get_edit_succeeds_for_artist_user
    membership = Membership.sham!
    login( membership.user )
    get :edit, :id => membership.artist
    assert_template 'current_artist'
    assert_response :success
  end

  def test_get_edit_succeeds_for_admin
    login( User.sham!(:admin) )
    get :edit, :id => Artist.sham!.to_param
    assert_template 'current_artist'
    assert_response :success
  end

  def test_get_edit_displays_headers_for_admin
    login( User.sham!(:admin) )
    artist = Artist.sham!
    get :edit, :id => artist.to_param
    assert_select "title", build_title( I18n.t( 'helpers.title.artist.edit' ), artist.name )
    assert_select 'h1', artist.name
    assert_select 'h2', I18n.t( 'helpers.title.artist.edit' )
  end

  def test_get_edit_displays_actions_for_admin
    login( User.sham!(:admin) )
    artist = Artist.sham!
    get :edit, :id => artist.to_param
    assert_select 'a[href=?]', artist_path( artist ), I18n.t( 'helpers.action.cancel_edit' )
  end

  def test_get_edit_displays_form_for_admin
    login( User.sham!(:admin) )
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

  def test_get_edit_displays_form_for_artist_user
    membership = Membership.sham!
    login( membership.user )
    artist = membership.artist
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

  def test_post_create_is_denied_for_guest
    assert_raises User::AccessDenied do
      post :create, :artist => {}
    end
  end

  def test_post_create_is_denied_for_user
    login( User.sham! )
    assert_raises User::AccessDenied do
      post :create, :artist => {}
    end
  end

  def test_post_create_creates_artist_for_admin
    login( User.sham!(:admin) )
    attributes = Artist.sham!( :build ).attributes
    artists_count = Artist.count
    post :create, :artist => attributes
    assert_equal artists_count + 1, Artist.count
    assert_redirected_to artist_url( assigns( :artist ) )
  end

  def test_put_update_is_denied_for_guest
    assert_raises User::AccessDenied do
      put :update, :id => Artist.sham!.to_param, :artist => {}
    end
  end

  def test_put_update_is_denied_for_user
    login( User.sham! )
    assert_raises User::AccessDenied do
      put :update, :id => Artist.sham!.to_param, :artist => {}
    end
  end

  def test_put_update_updates_artist_for_admin
    login( User.sham!(:admin) )
    artist = Artist.sham!
    name = Faker::Name.name
    put :update, :id => artist.to_param, :artist => {name: name}
    artist.reload
    assert_equal name, artist.name
    assert_redirected_to artist_url( assigns( :artist ) )
  end

  def test_put_update_updates_artist_for_artist_user
    membership = Membership.sham!
    login( membership.user )
    artist = membership.artist
    name = Faker::Name.name
    put :update, :id => artist.to_param, :artist => {name: name}
    artist.reload
    assert_equal name, artist.name
    assert_redirected_to artist_url( assigns( :artist ) )
  end
end

