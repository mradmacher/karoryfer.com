class MembershipPolicy < ApplicationPolicy
  def read_access_to?(membership)
    user_policy.read_access_to?(membership.user)
  end

  def write_access_to?(membership)
    current_user.admin? && user_policy.write_access_to?(membership.user)
  end

  def read_access?
    user_policy.read_access?
  end

  def write_access?
    user_policy.write_access?
  end

  private

  def user_policy
    @user_policy ||= UserPolicy.new(current_user)
  end
end
