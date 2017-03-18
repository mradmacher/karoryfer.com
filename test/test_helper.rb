ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'shams'
require 'minitest/mock'

dbconfig = Rails.configuration.database_configuration['test']
FIXTURES_DIR = File.expand_path('../fixtures', __FILE__)

module I18n
  def self.raise_missing_translation(*args)
    puts args.first
    puts args.first.class
    fail args.first.to_exception
  end
end
I18n.exception_handler = :raise_missing_translation

Uploader::Release.store_dir = '/tmp'
Attachment::Uploader.store_dir = '/tmp'
Uploader::TrackSource.store_dir = '/tmp'
Uploader::TrackPreview.store_dir = '/tmp'
Publisher.instance.name = 'Lecolds'
Publisher.instance.url = 'http://www.lecolds.com'

class ActiveSupport::TestCase
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

  DEFAULT_TITLE = 'Karoryfer Lecolds'
  TITLE_SEPARATOR = ' - '

  def build_title(*args)
    args << DEFAULT_TITLE
    args.join TITLE_SEPARATOR
  end

  def assert_headers(h1, h2 = nil, h3 = nil)
    assert_select 'h1', h1
    assert_select 'h2', h2 unless h2.nil?
    assert_select 'h3', h3 unless h3.nil?
  end

  def assert_title(*args)
    assert_select 'title', build_title(args)
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

  def login_artist_user
    membership = Membership.sham!
    login(membership.user)
    membership
  end

  def assert_authorized
    @controller.stub(:policy_class, AllowAllPolicy) do
      yield
    end
  end
end
