require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  def test_post_create_for_guest_is_denied
    assert_raise User::AccessDenied do
      post :create, membership: Membership.sham!( :build ).attributes
    end
  end

  def test_delete_destroy_for_guest_is_denied
    login( User.sham! )
    assert_raise User::AccessDenied do
      delete :destroy, id: Membership.sham!.to_param
    end
  end

  def test_post_create_for_user_is_denied
    login( User.sham! )
    assert_raise User::AccessDenied do
      post :create, membership: Membership.sham!( :build ).attributes
    end
  end

  def test_delete_destroy_for_user_is_denied
    login( User.sham! )
    assert_raise User::AccessDenied do
      delete :destroy, id: Membership.sham!.to_param
    end
  end

  def test_delete_destroy_for_artist_user_is_denied
    membership = Membership.sham!
    login( membership.user )
    assert_raise User::AccessDenied do
      delete :destroy, id: membership.id
    end
  end

  def test_post_create_for_admin_creates_membership
    login( User.sham!( :admin ) )
    membership = Membership.sham!( :build )
    count = Membership.count
    post :create, membership: membership.attributes
    assert_equal count + 1, Membership.count
  end

  def test_post_create_for_admin_redirects_to_user
    login( User.sham!( :admin ) )
    membership = Membership.sham!( :build )
    post :create, membership: membership.attributes
    assert_redirected_to admin_user_url( membership.user )
  end

  def test_delete_destroy_for_admin_removes_membership
    login( User.sham!( :admin ) )
    membership = Membership.sham!
    count = Membership.count
    delete :destroy, id: membership.to_param
    assert_equal count - 1, Membership.count
    refute Membership.where( id: membership.id ).exists?
  end

  def test_delete_destroy_for_admin_redirects_to_user
    login( User.sham!( :admin ) )
    membership = Membership.sham!
    delete :destroy, id: membership.to_param
    assert_redirected_to admin_user_url( membership.user )
  end
end

