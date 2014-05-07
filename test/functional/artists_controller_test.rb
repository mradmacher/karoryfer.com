require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  def test_get_index_succeeds
    get :index
    assert_response :success
  end

  def test_get_index_displays_headers
    get :index
    assert_select "title", build_title( I18n.t( 'title.artist.index' ) )
    assert_select "h1", I18n.t( 'title.artist.index' )
  end

  def test_get_index_does_not_display_actions_when_not_authorized
    deny(:write, Artist)
    get :index
    assert_select 'a[href=?]', new_artist_path, 0
  end

  def test_get_index_displays_actions_when_authorized
    allow(:write, Artist)
    get :index
    assert_select 'a[href=?]', new_artist_path
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

  def test_get_show_does_not_display_actions_when_not_authorized
    artist = Artist.sham!
    deny(:write, artist)
    get :show, :id => artist.to_param
    assert_select 'a[href=?]', edit_artist_path, 0
    assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
  end

  def test_get_show_displays_actions_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :show, :id => artist.to_param
    assert_select 'a[href=?]', edit_artist_path, I18n.t( 'action.edit' )
    assert_select 'a[href=?][data-method=delete]', artist_path( artist ), 0
  end

  def test_get_new_succeeds_when_authorized
    allow(:write, Artist)
    get :new
    assert_response :success
  end

  def test_get_new_displays_headers_when_authorized
    allow(:write, Artist)
    get :new
    assert_select "title", CGI.escape_html( build_title( I18n.t( 'title.artist.new' ) ) )
    assert_select "h1", CGI.escape_html( I18n.t( 'title.artist.new' ) )
  end

  def test_get_new_displays_form_when_authorized
    allow(:write, Artist)
    get :new
    assert_select 'form[enctype="multipart/form-data"]' do
      assert_select 'label', I18n.t( 'label.artist.name' )
      assert_select 'input[type=text][name=?]', 'artist[name]'
      assert_select 'label', I18n.t( 'label.artist.reference' )
      assert_select 'input[type=text][name=?]', 'artist[reference]'
      assert_select 'label', I18n.t( 'label.artist.image' )
      assert_select 'input[type=file][name=?]', 'artist[image]'
      assert_select 'label', I18n.t( 'label.artist.summary' )
      assert_select 'input[type=text][name=?]', 'artist[summary]'
      assert_select 'label', I18n.t( 'label.artist.description' )
      assert_select 'textarea[name=?]', 'artist[description]'
    end
  end

  def test_get_edit_succeeds_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :edit, :id => artist
    assert_template 'current_artist'
    assert_response :success
  end

  def test_get_edit_displays_headers_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :edit, :id => artist.to_param
    assert_select "title", build_title( artist.name )
    assert_select 'h1', artist.name
  end

  def test_get_edit_displays_actions_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :edit, :id => artist.to_param
    assert_select 'a[href=?]', artist_path( artist ), I18n.t( 'action.cancel_edit' )
  end

  def test_get_edit_displays_form_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :edit, :id => artist.to_param
    assert_select 'form[enctype="multipart/form-data"]' do
      assert_select 'label', I18n.t( 'label.artist.name' )
      assert_select 'input[type=text][name=?][value=?]', 'artist[name]', artist.name
      assert_select 'label', I18n.t( 'label.artist.reference' )
      assert_select 'input[type=text][name=?][value=?]', 'artist[reference]', artist.reference
      assert_select 'label', I18n.t( 'label.artist.image' )
      assert_select 'input[type=file][name=?]', 'artist[image]'
      assert_select 'label', I18n.t( 'label.artist.summary' )
      assert_select 'input[type=text][name=?]', 'artist[summary]', artist.summary
      assert_select 'label', I18n.t( 'label.artist.description' )
      assert_select 'textarea[name=?]', 'artist[description]', artist.description
    end
  end

  def test_post_create_creates_artist_when_authorized
    allow(:write, Artist)
    attributes = Artist.sham!( :build ).attributes
    artists_count = Artist.count
    post :create, :artist => attributes
    assert_equal artists_count + 1, Artist.count
    assert_redirected_to artist_url( assigns( :artist ) )
  end

  def test_put_update_updates_artist_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    name = Faker::Name.name
    put :update, :id => artist.to_param, :artist => {name: name}
    artist.reload
    assert_equal name, artist.name
    assert_redirected_to artist_url( assigns( :artist ) )
  end

  def test_get_edit_is_authorized
    artist = Artist.sham!
    assert_authorized :write, artist do
      get :edit, :id => artist.to_param
    end
  end

  def test_get_new_is_authorized
    assert_authorized :write, Artist do
      get :new
    end
  end

  def test_post_create_is_authorized
    assert_authorized :write, Artist do
      post :create, :artist => {}
    end
  end

  def test_put_update_is_authorized
    artist = Artist.sham!
    assert_authorized :write, artist do
      put :update, :id => artist.to_param, :artist => {}
    end
  end
end

