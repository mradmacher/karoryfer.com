require 'test_helper'
require_relative 'resources_controller_test/get_index'
require_relative 'resources_controller_test/get_show'
require_relative 'resources_controller_test/get_edit'
require_relative 'resources_controller_test/get_new'
require_relative 'resources_controller_test/put_update'
require_relative 'resources_controller_test/post_create'
require_relative 'resources_controller_test/delete_destroy'
require_relative 'resources_controller_test/authorize'

class PostsControllerTest < ActionController::TestCase
  include ResourcesControllerTest::GetIndex
  include ResourcesControllerTest::GetShow
  include ResourcesControllerTest::GetEdit
  include ResourcesControllerTest::GetNew
  include ResourcesControllerTest::PutUpdate
  include ResourcesControllerTest::PostCreate
  include ResourcesControllerTest::DeleteDestroy
  include ResourcesControllerTest::Authorize
  def resource_name
    'post'
  end

  def resource_class
    Post
  end

  def test_authorized_get_edit_displays_form
    artist = Artist.sham!
    post = Post.sham!( artist: artist )
    allow( :write, post )
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
    allow( :write, Post, artist )
    get :new, artist_id: artist
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.post.title' )
      assert_select 'input[type=text][name=?]', 'post[title]'
      assert_select 'label', I18n.t( 'label.post.body' )
      assert_select 'textarea[name=?]', 'post[body]'
    end
  end
end

