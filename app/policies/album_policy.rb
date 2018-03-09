# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  def read_access_to?(album)
    album.published? || current_user.persisted?
  end

  def write_access_to?(_album)
    current_user.publisher?
  end

  def write_access?
    current_user.persisted? && current_user.publisher?
  end

  def read_access?
    true
  end
end
