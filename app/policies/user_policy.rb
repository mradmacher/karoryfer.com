class UserPolicy < ApplicationPolicy
  def read?(user)
    current_user.admin? || current_user == user
  end

  def write?(user)
    read?(user)
  end

  def read_access?
    current_user.persisted?
  end

  def write_access?
    read_access?
  end
end
