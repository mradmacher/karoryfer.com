require 'test_helper'
require_relative 'resources_controller'

class PostsControllerTest < ActionController::TestCase
  include ResourcesController

  def resource_name
    'post'
  end

  def resource_class
    Post
  end

  def test_authorized_get_edit_displays_form
    artist = Artist.sham!
    post = Post.sham!(artist: artist)
    allow(:write_post, artist)
    get :edit, artist_id: post.artist.to_param, id: post.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.post.title' )
      assert_select 'input[type=text][name=?][value=?]', 'post[title]', post.title
      assert_select 'label', I18n.t( 'label.post.body' )
      assert_select 'textarea[name=?]', 'post[body]', :text => post.body
    end
  end

  def test_authorized_get_new_displays_form
    artist = Artist.sham!
    allow(:write_post, artist)
    get :new, artist_id: artist
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.post.title' )
      assert_select 'input[type=text][name=?]', 'post[title]'
      assert_select 'label', I18n.t( 'label.post.body' )
      assert_select 'textarea[name=?]', 'post[body]'
    end
  end
end
