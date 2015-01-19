require 'test_helper'

# Tests for user cruder.
class UserCruderTest < ActiveSupport::TestCase
  def test_protects_admin_flag_from_mass_assignment
    user = User.sham!
    other_user = User.sham!(admin: false)
    with_permission_to :write, other_user do |abilities|
      cruder({ id: other_user.to_param,
        user: { admin: true } }, abilities).update
    end
    other_user.reload
    refute other_user.admin?
  end

  def test_allows_mass_assignment_of_admin_flag_by_admin
    user = User.sham!
    other_user = User.sham!(admin: false)
    with_permission_to :write, User do |abilities|
      cruder({ id: other_user.to_param,
        user: { admin: true } }, abilities).update
    end
    other_user.reload
    assert other_user.admin?
  end

  def test_protects_publisher_flag_from_mass_assignment
    user = User.sham!
    other_user = User.sham!(publisher: false)
    with_permission_to :write, other_user do |abilities|
      cruder({ id: other_user.to_param,
        user: { publisher: true } }, abilities).update
    end
    other_user.reload
    refute other_user.publisher?
  end

  def test_allows_mass_assignment_of_publisher_flag_by_admin
    user = User.sham!(:admin)
    other_user = User.sham!(publisher: false)
    with_permission_to :write, User do |abilities|
      cruder({ id: other_user.to_param,
        user: { publisher: true } }, abilities).update
    end
    other_user.reload
    assert other_user.publisher?
  end

  def cruder(params, abilities)
    UserCruder.new(abilities, params)
  end
end
