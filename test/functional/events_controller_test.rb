require 'test_helper'
require_relative 'resources_controller_test/get_index'
require_relative 'resources_controller_test/get_drafts'
require_relative 'resources_controller_test/get_show'
require_relative 'resources_controller_test/get_show_draft'
require_relative 'resources_controller_test/get_edit'
require_relative 'resources_controller_test/get_new'
require_relative 'resources_controller_test/put_update'
require_relative 'resources_controller_test/post_create'
require_relative 'resources_controller_test/delete_destroy'

class EventsControllerTest < ActionController::TestCase
  include ResourcesControllerTest::GetIndex
  include ResourcesControllerTest::GetDrafts
  include ResourcesControllerTest::GetShow
  include ResourcesControllerTest::GetShowDraft
  include ResourcesControllerTest::GetEdit
  include ResourcesControllerTest::GetNew
  include ResourcesControllerTest::PutUpdate
  include ResourcesControllerTest::PostCreate
  include ResourcesControllerTest::DeleteDestroy

  def resource_name
    'event'
  end

  def resource_class
    Event
  end

  def test_get_edit_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    event = Event.sham!( artist: membership.artist )
    get :edit, :artist_id => event.artist.to_param, :id => event.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'helpers.label.event.artist_id' )
      assert_select 'select[name=?]', 'event[artist_id]'
      assert_select 'label', I18n.t( 'helpers.label.event.title' )
      assert_select 'input[type=text][name=?][value=?]', 'event[title]', event.title
      assert_select 'label', I18n.t( 'helpers.label.event.published' )
      assert_select 'label', I18n.t( 'helpers.label.event.poster_url' )
      assert_select 'input[type=text][name=?]', 'event[poster_url]'
      unless event.poster_url.nil?
        assert_select 'input[type=text][name=?][value=?]', 'event[poster_url]', event.poster_url
      end
      assert_select 'label', I18n.t( 'helpers.label.event.body' )
      assert_select 'textarea[name=?]', 'event[body]',
        :text => event.body
    end
  end

  def test_get_new_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    available_artists = [membership.artist]
    get :new
    assert_select 'form' do
      assert_select 'label', I18n.t( 'helpers.label.event.artist_id' )
      assert_select 'select[name=?]', 'event[artist_id]'
      assert_select 'label', I18n.t( 'helpers.label.event.title' )
      assert_select 'input[type=text][name=?]', 'event[title]'
      assert_select 'label', I18n.t( 'helpers.label.event.published' )
      assert_select 'label', I18n.t( 'helpers.label.event.poster_url' )
      assert_select 'input[type=text][name=?]', 'event[poster_url]'
      assert_select 'label', I18n.t( 'helpers.label.event.body' )
      assert_select 'textarea[name=?]', 'event[body]'
    end
  end
end

