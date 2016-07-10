class TrackPolicy < ApplicationPolicy
  def read?(track)
    album_policy.read?(track.album)
  end

  def write?(track)
    album_policy.write?(track.album)
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
