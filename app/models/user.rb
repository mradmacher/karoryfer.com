# frozen_string_literal: true

class User < ApplicationRecord
  class AccessDenied < StandardError
  end

  acts_as_authentic do |c|
    c.transition_from_crypto_providers = [Authlogic::CryptoProviders::Sha512]
    c.crypto_provider = Authlogic::CryptoProviders::SCrypt
  end

  validates :admin, inclusion: { in: [true, false] }
  validates :publisher, inclusion: { in: [true, false] }

  validates :password,
            confirmation: { if: :require_password? },
            length: { minimum: 8, if: :require_password? }
end
