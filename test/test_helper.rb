# frozen_string_literal: true

# ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'shams'
require 'minitest/mock'
require 'minitest/autorun'

FIXTURES_DIR = File.expand_path('fixtures', __dir__)

module I18n
  def self.raise_missing_translation(*args)
    puts args.first
    puts args.first.class
    raise args.first.to_exception
  end
end
I18n.exception_handler = :raise_missing_translation

Uploader::Release.store_dir = '/tmp'
Attachment::Uploader.store_dir = '/tmp'
Uploader::TrackSource.store_dir = '/tmp'
Uploader::TrackPreview.store_dir = '/tmp'

module ActiveSupport
  class TestCase
    def login(user)
      activate_authlogic
      UserSession.create user
    end

    def login_user
      user = User.sham!
      login(user)
      user
    end
  end
end
