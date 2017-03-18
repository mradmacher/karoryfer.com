class UserPolicy < ApplicationPolicy
  def read_access_to?(user)
    current_user.admin? || current_user == user
  end

  def write_access_to?(user)
    read_access_to?(user)
  end

  def read_access?
    current_user.persisted?
  end

  def write_access?
    read_access?
  end
end
