class PagePolicy < ApplicationPolicy
  def read?(page)
    artist_policy.read?(page.artist)
  end

  def write?(page)
    artist_policy.write?(page.artist)
  end

  def read_access?
    artist_policy.read_access?
  end

  def write_policy?
    artist_policy.write_access?
  end

  private

  def artist_policy
    @artist_policy ||= ArtistPolicy.new(current_user)
  end
end
