require 'test_helper'
require_relative 'resources_controller_test/get_index'
require_relative 'resources_controller_test/get_show'
require_relative 'resources_controller_test/get_edit'
require_relative 'resources_controller_test/get_new'
require_relative 'resources_controller_test/put_update'
require_relative 'resources_controller_test/post_create'
require_relative 'resources_controller_test/delete_destroy'

class PagesControllerTest < ActionController::TestCase
  #include ResourcesControllerTest::GetIndex
  include ResourcesControllerTest::GetShow
  include ResourcesControllerTest::GetEdit
  include ResourcesControllerTest::GetNew
  include ResourcesControllerTest::PutUpdate
  include ResourcesControllerTest::PostCreate
  include ResourcesControllerTest::DeleteDestroy

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
    membership = Membership.sham!
    login( membership.user )
    resource = resource_class.sham!( artist: membership.artist )
    delete :destroy, artist_id: resource.artist.to_param, id: resource.to_param
    assert_redirected_to send( "artist_path",  resource.artist )
  end

  def test_get_edit_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    page = Page.sham!( artist: membership.artist )
    get :edit, artist_id: page.artist.to_param, id: page.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'helpers.label.page.title' )
      assert_select 'input[type=text][name=?][value=?]', 'page[title]', page.title
      assert_select 'label', I18n.t( 'helpers.label.page.reference' )
      assert_select 'input[type=text][name=?][value=?][disabled=disabled]', 'page[reference]', page.reference
      assert_select 'label', I18n.t( 'helpers.label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]', page.content
      assert_select 'button[type=submit]'
    end
  end

  def test_get_new_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    get :new, artist_id: membership.artist.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'helpers.label.page.title' )
      assert_select 'input[type=text][name=?]', 'page[title]'
      assert_select 'label', I18n.t( 'helpers.label.page.reference' )
      assert_select 'input[type=text][name=?][disabled=disabled]', 'page[reference]', 0
      assert_select 'input[type=text][name=?]', 'page[reference]'
      assert_select 'label', I18n.t( 'helpers.label.page.content' )
      assert_select 'textarea[name=?]', 'page[content]'
      assert_select 'button[type=submit]'
    end
  end
end

