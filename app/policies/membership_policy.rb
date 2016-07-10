class MembershipPolicy < ApplicationPolicy
  def read?(membership)
    user_policy.read?(membership.user)
  end

  def write?(membership)
    current_user.admin? && user_policy.write?(membership.user)
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
