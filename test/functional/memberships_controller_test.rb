require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def test_post_create_is_authorized
    assert_authorized :write, Membership do
      post :create, membership: Membership.sham!(:build).attributes
    end
  end

  def test_delete_destroy_is_authorized
    membership = Membership.sham!
    assert_authorized :write, membership do
      delete :destroy, id: membership.to_param
    end
  end

  def test_authorized_post_create_creates_membership
    allow(:write, Membership)
    membership = Membership.sham!(:build)
    count = Membership.count
    post :create, membership: membership.attributes
    assert_equal count + 1, Membership.count
  end

  def test_authorized_post_create_redirects_to_user
    allow(:write, Membership)
    membership = Membership.sham!(:build)
    post :create, membership: membership.attributes
    assert_redirected_to admin_user_url( membership.user )
  end

  def test_authorized_delete_destroy_removes_membership
    membership = Membership.sham!
    allow(:write, membership)
    count = Membership.count
    delete :destroy, id: membership.to_param
    assert_equal count - 1, Membership.count
    refute Membership.where( id: membership.id ).exists?
  end

  def test_authorized_delete_destroy_redirects_to_user
    membership = Membership.sham!
    allow(:write, membership)
    delete :destroy, id: membership.to_param
    assert_redirected_to admin_user_url( membership.user )
  end
end

