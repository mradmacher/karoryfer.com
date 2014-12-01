require 'test_helper'
require_relative 'resources_controller'

class PagesControllerTest < ActionController::TestCase
  include ResourcesController

  def resource_name
    'page'
  end

  def resource_class
    Page
  end

  def test_get_show_for_guest_displays_headers
    resource = resource_class.sham!
    get :show, artist_id: resource.artist.to_param, id: resource.to_param
    assert_select "title", build_title( resource.title, resource.artist.name )
    assert_select 'h1', resource.artist.name
    assert_select 'h2', resource.title
  end

  def test_delete_destroy_for_artist_user_properly_redirects
    membership = login_artist_user
    resource = resource_class.sham!( artist: membership.artist )
    delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
    assert_redirected_to send( "artist_path",  resource.artist )
  end

  def test_get_edit_for_artist_user_displays_form
    membership = login_artist_user
    page = Page.sham!( artist: membership.artist )
    get :edit, artist_id: page.artist.to_param, id: page.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.page.title' )
      assert_select 'input[type=text][name=?][value=?]', 'page[title]', page.title
      assert_select 'label', I18n.t( 'label.page.reference' )
      assert_select 'input[type=text][name=?][value=?][disabled=disabled]', 'page[reference]', page.reference
      assert_select 'label', I18n.t( 'label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]', page.content
      assert_select 'button[type=submit]'
    end
  end

  def test_get_new_for_artist_user_displays_form
    membership = login_artist_user
    get :new, artist_id: membership.artist.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.page.title' )
      assert_select 'input[type=text][name=?]', 'page[title]'
      assert_select 'label', I18n.t( 'label.page.reference' )
      assert_select 'input[type=text][name=?][disabled=disabled]', 'page[reference]', 0
      assert_select 'input[type=text][name=?]', 'page[reference]'
      assert_select 'label', I18n.t( 'label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]'
      assert_select 'button[type=submit]'
    end
  end
end

