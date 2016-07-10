class ArtistPolicy < ApplicationPolicy
  def read?(_artist)
    true
  end

  def write?(artist)
    member_of?(artist)
  end

  def write_access?
    current_user.persisted?
  end

  def read_access?
    true
  end
end
