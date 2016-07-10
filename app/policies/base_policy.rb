class BasePolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def write?(_resource)
    false
  end

  def read?(_resource)
    false
  end

  def write_access?
    false
  end

  def read_access?
    false
  end
end

