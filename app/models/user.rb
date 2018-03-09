# frozen_string_literal: true

class User < ActiveRecord::Base
  class AccessDenied < StandardError
  end

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  validates :admin, inclusion: { in: [true, false] }
  validates :publisher, inclusion: { in: [true, false] }
end
