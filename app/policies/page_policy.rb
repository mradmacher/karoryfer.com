class PagePolicy < ApplicationPolicy
  def read_access_to?(page)
    artist_policy.read_access_to?(page.artist)
  end

  def write_access_to?(page)
    artist_policy.write_access_to?(page.artist)
  end

  def read_access?
    artist_policy.read_access?
  end

  def write_access?
    artist_policy.write_access?
  end

  private

  def artist_policy
    @artist_policy ||= ArtistPolicy.new(current_user)
  end
end
