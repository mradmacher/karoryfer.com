require 'test_helper'

# Tests for user resource.
class UserResourceTest < ActiveSupport::TestCase
  def test_index_is_authorized
    assert_authorization :read, User do |abilities|
      resourcer({}, abilities).index
    end
  end

  def test_edit_is_authorized
    user = User.sham!
    assert_authorization :write, user do |abilities|
      resourcer({ id: user.to_param }, abilities).edit
    end
  end

  def test_new_is_authorized
    assert_authorization :write, User do |abilities|
      resourcer({}, abilities).new
    end
  end

  def test_show_is_authorized
    user = User.sham!
    assert_authorization :read, user do |abilities|
      resourcer({ id: user.to_param }, abilities).show
    end
  end

  def test_destroy_is_authorized
    user = User.sham!
    assert_authorization :write, user do |abilities|
      resourcer({ id: user.to_param }, abilities).destroy
    end
  end

  def test_create_is_authorized
    attributes = User.sham!(:build).attributes.merge(
      password: 'crypted01!', password_confirmation: 'crypted01!')
    assert_authorization :write, User do |abilities|
      resourcer({ user: attributes }, abilities).create
    end
  end

  def test_update_is_authorized
    user = User.sham!
    assert_authorization :write, user do |abilities|
      resourcer({ id: user.to_param, user: {dummy: 1} }, abilities).update
    end
  end

  def test_authorized_show_returns_user
    user = User.sham!
    with_permission_to :read,  user do |abilities|
      result = resourcer({ id: user.to_param }, abilities).show
      assert_equal user, result
    end
  end

  def test_authorized_edit_returns_user
    user = User.sham!
    with_permission_to :write,  user do |abilities|
      result = resourcer({ id: user.to_param }, abilities).edit
      assert_equal user, result
    end
  end

  def test_authorized_index_succeeds
    user = User.sham!
    with_permission_to :read, User do |abilities|
      result = resourcer({}, abilities).index
      assert_equal [user], result
    end
  end

  def test_authorized_new_returns_new_user
    with_permission_to :write, User do |abilities|
      result = resourcer({}, abilities).new
      assert result.is_a? User
      refute result.persisted?
    end
  end

  def test_protects_admin_flag_from_mass_assignment
		user = User.sham!
    other_user = User.sham!(admin: false)
    with_permission_to :write, other_user do |abilities|
      resourcer({ id: other_user.to_param,
        user: { admin: true } }, abilities).update
    end
    other_user.reload
		refute other_user.admin?
	end

	def test_allows_mass_assignment_of_admin_flag_by_admin
		user = User.sham!
    other_user = User.sham!(admin: false)
    with_permission_to :write, User do |abilities|
      resourcer({ id: other_user.to_param,
        user: { admin: true } }, abilities).update
    end
    other_user.reload
    assert other_user.admin?
	end

  def test_protects_publisher_flag_from_mass_assignment
		user = User.sham!
    other_user = User.sham!(publisher: false)
    with_permission_to :write, other_user do |abilities|
      resourcer({ id: other_user.to_param,
        user: { publisher: true } }, abilities).update
    end
    other_user.reload
		refute other_user.publisher?
	end

	def test_allows_mass_assignment_of_publisher_flag_by_admin
		user = User.sham!(:admin)
    other_user = User.sham!(publisher: false)
    with_permission_to :write, User do |abilities|
      resourcer({ id: other_user.to_param,
        user: { publisher: true } }, abilities).update
    end
    other_user.reload
		assert other_user.publisher?
	end

  def resourcer(params, abilities)
    Resource::UserResource.new(params, abilities)
  end
end
