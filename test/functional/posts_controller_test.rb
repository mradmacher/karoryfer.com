require 'test_helper'
require_relative 'resources_controller_test/get_index'
require_relative 'resources_controller_test/get_show'
require_relative 'resources_controller_test/get_edit'
require_relative 'resources_controller_test/get_new'
require_relative 'resources_controller_test/put_update'
require_relative 'resources_controller_test/post_create'
require_relative 'resources_controller_test/delete_destroy'

class PostsControllerTest < ActionController::TestCase
  include ResourcesControllerTest::GetIndex
  include ResourcesControllerTest::GetShow
  include ResourcesControllerTest::GetEdit
  include ResourcesControllerTest::GetNew
  include ResourcesControllerTest::PutUpdate
  include ResourcesControllerTest::PostCreate
  include ResourcesControllerTest::DeleteDestroy
  def resource_name
    'post'
  end

  def resource_class
    Post
  end

  def test_get_edit_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    post = Post.sham!( artist: membership.artist )
    get :edit, artist_id: post.artist.to_param, id: post.to_param
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.post.title' )
      assert_select 'input[type=text][name=?][value=?]', 'post[title]', post.title
      assert_select 'label', I18n.t( 'label.post.body' )
      assert_select 'textarea[name=?]', 'post[body]', :text => post.body
    end
  end

  def test_get_new_for_artist_user_displays_form
    membership = Membership.sham!
    login( membership.user )
    get :new, artist_id: membership.artist
    assert_select 'form' do
      assert_select 'label', I18n.t( 'label.post.title' )
      assert_select 'input[type=text][name=?]', 'post[title]'
      assert_select 'label', I18n.t( 'label.post.body' )
      assert_select 'textarea[name=?]', 'post[body]'
    end
  end
end

