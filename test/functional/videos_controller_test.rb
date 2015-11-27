require 'test_helper'
require_relative 'resources_controller'

class VideosControllerTest < ActionController::TestCase
  include ResourcesController

  def resource_name
    'video'
  end

  def resource_class
    Video
  end

  def test_authorized_get_edit_displays_form
    artist = Artist.sham!
    video = Video.sham!(artist: artist)
    allow(:write_video, artist)
    get :edit, artist_id: video.artist.to_param, id: video.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t('label.video.title')
      assert_select 'input[type=text][name=?][value=?]', 'video[title]', video.title
      assert_select 'label', I18n.t('label.video.url')
      assert_select 'input[type=text][name=?][value=?]', 'video[url]', video.url
      assert_select 'label', I18n.t('label.video.body')
      assert_select 'textarea[name=?]', 'video[body]', text: video.body
    end
  end

  def test_authorized_get_new_displays_form
    artist = Artist.sham!
    allow(:write_video, artist)
    get :new, artist_id: artist
    assert_select 'form' do
      assert_select 'label', I18n.t('label.video.title')
      assert_select 'input[type=text][name=?]', 'video[title]'
      assert_select 'label', I18n.t('label.video.url')
      assert_select 'input[type=text][name=?]', 'video[url]'
      assert_select 'label', I18n.t('label.video.body')
      assert_select 'textarea[name=?]', 'video[body]'
    end
  end
end
