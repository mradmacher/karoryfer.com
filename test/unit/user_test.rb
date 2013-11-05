require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_is_not_admin_by_default
		user = User.new
		refute user.admin?
	end

  def test_is_admin_or_not
		user = User.new
		user.admin = nil
		refute user.valid?
		assert user.errors[:admin].include? I18n.t( 
      'activerecord.errors.models.user.attributes.admin.inclusion' )
	end

  def test_protects_admin_flag_from_mass_assignment
		user = User.new 		
		user.admin = false
		user.assign_attributes :admin => true
		refute user.admin?
	end

	def test_allows_mass_assignment_of_admin_flag_by_admin
		user = User.new 		
		user.admin = false
		user.assign_attributes( {:admin => true}, :as => :admin )
		assert user.admin?
	end
end

