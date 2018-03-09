# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'shams'
require 'minitest/mock'

FIXTURES_DIR = File.expand_path('../fixtures', __FILE__)

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
    class AllowAllPolicy < BasePolicy
      def write_access_to?(_)
        true
      end

      def read_access_to?(_)
        true
      end

      def write_access?
        true
      end

      def read_access?
        true
      end
    end

    def login(user)
      activate_authlogic
      UserSession.create user
    end

    def login_user
      user = User.sham!
      login(user)
      user
    end

    def login_admin
      user = User.sham!(:admin)
      login(user)
      user
    end

    def assert_authorized
      @controller.stub(:policy_class, AllowAllPolicy) do
        yield
      end
    end
  end
end
