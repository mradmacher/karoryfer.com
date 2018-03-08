# frozen_string_literal: true

class User < ActiveRecord::Base
  class AccessDenied < StandardError
  end

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  has_many :memberships

  validates :admin, inclusion: { in: [true, false] }
  validates :publisher, inclusion: { in: [true, false] }

  def artists
    Artist.joins(:memberships).where('memberships.user_id' => id)
  end

  def other_artists
    artist_ids = artists.pluck(:id)
    if artist_ids.empty?
      Artist.all
    else
      Artist.where('id not in (?)', artist_ids)
    end
  end
end
