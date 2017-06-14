class ArtistPolicy < ApplicationPolicy
  def read_access_to?(_artist)
    true
  end

  def write_access_to?(artist)
    member_of?(artist)
  end

  def write_access?
    current_user.persisted?
  end

  def read_access?
    true
  end
end