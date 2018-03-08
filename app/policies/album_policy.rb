# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  def read_access_to?(album)
    album.published? || member_of?(album.artist)
  end

  def write_access_to?(album)
    member_of?(album.artist)
  end

  def write_access?
    current_user.persisted? && current_user.publisher?
  end

  def read_access?
    true
  end
end
