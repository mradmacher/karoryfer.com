require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def test_post_create_is_authorized
    user = User.sham!
    assert_authorized :write_membership, user do
      post :create, user_id: user.to_param,
                    membership: Membership.sham!(:build).attributes
    end
  end

  def test_delete_destroy_is_authorized
    membership = Membership.sham!
    assert_authorized :write_membership, membership.user do
      delete :destroy, user_id: membership.user.to_param,
                       id: membership.to_param
    end
  end

  def test_authorized_post_create_creates_membership
    user = User.sham!
    allow(:write_membership, user)
    membership = Membership.sham!(:build)
    count = Membership.count
    post :create, user_id: user.to_param, membership: membership.attributes
    assert_equal count + 1, Membership.count
  end

  def test_authorized_post_create_redirects_to_user
    user = User.sham!
    allow(:write_membership, user)
    membership = Membership.sham!(:build)
    post :create, user_id: user.to_param, membership: membership.attributes
    assert_redirected_to admin_user_url(user)
  end

  def test_authorized_delete_destroy_removes_membership
    membership = Membership.sham!
    allow(:write_membership, membership.user)
    count = Membership.count
    delete :destroy, user_id: membership.user.to_param, id: membership.to_param
    assert_equal count - 1, Membership.count
    refute Membership.where(id: membership.id).exists?
  end

  def test_authorized_delete_destroy_redirects_to_user
    membership = Membership.sham!
    allow(:write_membership, membership.user)
    delete :destroy, user_id: membership.user.to_param, id: membership.to_param
    assert_redirected_to admin_user_url(membership.user)
  end
end
