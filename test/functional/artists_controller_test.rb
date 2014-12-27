require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
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

  def test_get_edit_displays_headers_when_authorized
    artist = Artist.sham!
    allow(:write, artist)
    get :edit, :id => artist.to_param
    assert_select "title", build_title(artist.name)
    assert_select 'h1', artist.name
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
end
