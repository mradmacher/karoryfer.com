# frozen_string_literal: true

require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  def test_get_show_succeeds
    login_user
    user = User.sham!
    get :show, params: { id: user.to_param }
    assert_response :success
  end

  def test_get_edit_succeeds
    login_user
    user = User.sham!
    get :edit, params: { id: user.to_param }
    assert_response :success
  end

  def test_get_edit_password_succeeds
    login_user
    user = User.sham!
    get :edit_password, params: { id: user.to_param }
    assert_response :success
  end

  def test_get_index_succeeds
    login_user
    get :index
    assert_response :success
  end

  def test_get_new_succeeds
    login_user
    get :new
    assert_response :success
  end
end
