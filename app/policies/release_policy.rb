# frozen_string_literal: true

class ReleasePolicy < ApplicationPolicy
  def read_access_to?(release)
    album_policy.read_access_to?(release.album)
  end

  def write_access_to?(release)
    album_policy.write_access_to?(release.album)
  end

  def read_access?
    album_policy.read_access?
  end

  def write_access?
    album_policy.write_access?
  end

  private

  def album_policy
    @album_policy ||= AlbumPolicy.new(current_user)
  end
end
