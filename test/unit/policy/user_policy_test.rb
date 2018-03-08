# frozen_string_literal: true

require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  def test_accessing_user_resources_for_guest_is_denied
    current_user = User.new
    user = User.new
    refute UserPolicy.new(current_user).read?(user)
    refute MembershipPolicy.new(current_user).read?(Membership.new(user: user))
  end

  def test_managing_user_resources_for_guest_is_denied
    current_user = User.new
    user = User.new
    refute UserPolicy.new(current_user).write?(user)
    refute MembershipPolicy.new(current_user).write?(Membership.new(user: user))
  end

  def test_managing_account_is_allowed
    current_user = User.new
    user = current_user
    assert UserPolicy.new(current_user).read?(user)
    assert UserPolicy.new(current_user).write?(user)
    assert MembershipPolicy.new(current_user).read?(Membership.new(user: user))
  end

  def test_managing_account_resources_is_denied
    current_user = User.new
    user = current_user
    refute MembershipPolicy.new(current_user).write?(Membership.new(user: user))
  end

  def test_managing_user_resources_for_admin_is_allowed
    current_user = User.new(admin: true)
    user = User.new
    assert UserPolicy.new(current_user).read?(user)
    assert MembershipPolicy.new(current_user).read?(Membership.new(user: user))
    assert UserPolicy.new(current_user).write?(user)
    assert MembershipPolicy.new(current_user).write?(Membership.new(user: user))
  end

  def test_visitor_has_not_read_nor_write_access
    policy = UserPolicy.new(User.new)
    refute policy.read_access?
    refute policy.write_access?
  end

  def test_user_has_read_and_write_access
    policy = UserPolicy.new(User.sham!)
    assert policy.read_access?
    assert policy.write_access?
  end
end
