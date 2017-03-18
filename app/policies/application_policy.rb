class ApplicationPolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def read?(record)
    read_access? && read_access_to?(record)
  end

  def write?(record)
    write_access? && write_access_to?(record)
  end

  def read_access?
    true
  end

  def write_access?
    true
  end

  def read_access_to?(_record)
    false
  end

  def write_access_to?(_record)
    false
  end

  def member_of?(artist)
    current_user.memberships.map(&:artist_id).include?(artist&.id)
  end
end
