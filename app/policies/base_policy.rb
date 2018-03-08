# frozen_string_literal: true

class BasePolicy
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def write_access_to?(_resource)
    false
  end

  def read_access_to?(_resource)
    false
  end

  def write_access?
    false
  end

  def read_access?
    false
  end
end
