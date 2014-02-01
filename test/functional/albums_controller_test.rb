require 'test_helper'
require_relative 'albums_controller_tests/get_index'
require_relative 'albums_controller_tests/get_show'
require_relative 'albums_controller_tests/get_edit'
require_relative 'albums_controller_tests/get_new'
require_relative 'albums_controller_tests/put_update'
require_relative 'albums_controller_tests/post_create'
require_relative 'albums_controller_tests/delete_destroy'

class AlbumsControllerTest < ActionController::TestCase
  include AlbumsControllerTests::GetIndex
  include AlbumsControllerTests::GetShow
  include AlbumsControllerTests::GetEdit
  include AlbumsControllerTests::GetNew
  include AlbumsControllerTests::PutUpdate
  include AlbumsControllerTests::PostCreate
  include AlbumsControllerTests::DeleteDestroy
end

