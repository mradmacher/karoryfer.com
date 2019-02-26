# frozen_string_literal: true

class User < ApplicationRecord
  class AccessDenied < StandardError
  end

  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  validates :admin, inclusion: { in: [true, false] }
  validates :publisher, inclusion: { in: [true, false] }

  validates :password,
            confirmation: { if: :require_password? },
            length: { minimum: 8, if: :require_password? }
end
