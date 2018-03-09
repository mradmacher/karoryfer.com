# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_authorized_get_show_succeeds
    user = User.sham!
    assert_authorized do
      get :show, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_edit_succeeds
    user = User.sham!
    assert_authorized do
      get :edit, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_edit_password_succeeds
    user = User.sham!
    assert_authorized do
      get :edit_password, id: user.to_param
    end
    assert_response :success
  end

  def test_authorized_get_index_succeeds
    assert_authorized do
      get :index
    end
    assert_response :success
  end

  def test_authorized_get_new_succeeds
    assert_authorized do
      get :new
    end
    assert_response :success
  end
end
