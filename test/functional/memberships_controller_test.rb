# frozen_string_literal: true

require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def test_post_create_is_authorized
    user = User.sham!
    assert_authorized do
      post :create, user_id: user.to_param,
                    membership: Membership.sham!(:build).attributes
    end
  end

  def test_delete_destroy_is_authorized
    membership = Membership.sham!
    assert_authorized do
      delete :destroy, user_id: membership.user.to_param,
                       id: membership.to_param
    end
  end

  def test_authorized_post_create_creates_membership
    user = User.sham!
    membership = Membership.sham!(:build)
    count = Membership.count
    assert_authorized do
      post :create, user_id: user.to_param, membership: membership.attributes
    end
    assert_equal count + 1, Membership.count
  end

  def test_authorized_post_create_redirects_to_user
    user = User.sham!
    membership = Membership.sham!(:build)
    assert_authorized do
      post :create, user_id: user.to_param, membership: membership.attributes
    end
    assert_redirected_to admin_user_url(user)
  end

  def test_authorized_delete_destroy_removes_membership
    membership = Membership.sham!
    count = Membership.count
    assert_authorized do
      delete :destroy, user_id: membership.user.to_param, id: membership.to_param
    end
    assert_equal count - 1, Membership.count
    refute Membership.where(id: membership.id).exists?
  end

  def test_authorized_delete_destroy_redirects_to_user
    membership = Membership.sham!
    assert_authorized do
      delete :destroy, user_id: membership.user.to_param, id: membership.to_param
    end
    assert_redirected_to admin_user_url(membership.user)
  end
end
