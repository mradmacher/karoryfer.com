# frozen_string_literal: true

class ArtistPolicy < ApplicationPolicy
  def read_access_to?(_artist)
    true
  end

  def write_access_to?(_artist)
    write_access?
  end

  def write_access?
    current_user.persisted?
  end

  def read_access?
    true
  end
end
