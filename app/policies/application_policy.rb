class ApplicationPolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def read?(_record)
    false
  end

  def write?(_record)
    false
  end

  def read_access?
    true
  end

  def write_access?
    true
  end

  def member_of?(artist)
    current_user.memberships.map(&:artist_id).include?(artist&.id)
  end
end
