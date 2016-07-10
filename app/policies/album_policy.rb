class AlbumPolicy < ApplicationPolicy
  def read?(album)
    album.published? || member_of?(album.artist)
  end

  def write?(album)
    current_user.publisher? && member_of?(album.artist)
  end

  def write_access?
    current_user.persisted? && current_user.publisher?
  end

  def read_access?
    true
  end
end
