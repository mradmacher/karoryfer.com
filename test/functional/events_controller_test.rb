require 'test_helper'
require_relative 'resources_controller'

class EventsControllerTest < ActionController::TestCase
  include ResourcesController

  def resource_name
    'event'
  end

  def resource_class
    Event
  end

  def test_authorized_get_edit_displays_form
    artist = Artist.sham!
    event = Event.sham!(artist: artist)
    allow(:write_event, artist)
    get :edit, artist_id: event.artist.to_param, id: event.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.event.title' )
      assert_select 'input[type=text][name=?][value=?]', 'event[title]', event.title
      assert_select 'label', I18n.t( 'label.event.body' )
      assert_select 'textarea[name=?]', 'event[body]',
        :text => event.body
    end
  end

  def test_authorized_get_new_displays_form
    artist = Artist.sham!
    allow(:write_event, artist)
    get :new, artist_id: artist
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.event.title' )
      assert_select 'input[type=text][name=?]', 'event[title]'
      assert_select 'label', I18n.t( 'label.event.body' )
      assert_select 'textarea[name=?]', 'event[body]'
    end
  end
end
