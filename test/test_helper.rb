ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
require 'sequel'
require 'shams'

dbconfig = Rails.configuration.database_configuration['test']
DB = Sequel.connect( "postgres://#{dbconfig['username']}@localhost/#{dbconfig['database']}" )
FIXTURES_DIR = File.expand_path('../fixtures', __FILE__)

module I18n
	def self.raise_missing_translation( *args )
		puts args.first
		puts args.first.class
		raise args.first.to_exception
	end
end
I18n.exception_handler = :raise_missing_translation

Uploader::Release.album_store_dir = "/tmp"
Uploader::Release.track_store_dir = "/tmp"
Attachment::Uploader.store_dir = "/tmp"
Track::Uploader.store_dir = "/tmp"
Publisher.instance.name = 'Lecolds'
Publisher.instance.url = 'http://www.lecolds.com'

class ActiveSupport::TestCase
  class TestAbility
    def initialize
      @allowed = []
    end

    def allow(action, subject, scope = nil)
      @allowed << [action, subject, scope]
    end

    def allowed?(action, subject, scope = nil)
      !@allowed.select{ |e| match_action?(e[0], action) and match_subject?(e[1], subject) and e[2] == scope }.empty?
    end

    private
    def match_action?(expected, actual)
      expected == actual
    end

    def match_subject?(expected, actual)
      if expected.class == Class and actual.class == Class
        expected == actual
      elsif expected.class == Class
        expected == actual.class
      else
        expected == actual
      end
    end
  end

	DEFAULT_TITLE = 'Karoryfer Lecolds'
	TITLE_SEPARATOR = ' - '

	def build_title *args
		args << DEFAULT_TITLE
		args.join TITLE_SEPARATOR
	end

	def assert_headers( h1, h2 = nil, h3 = nil )
		assert_select "h1", h1
		assert_select "h2", h2 unless h2.nil?
		assert_select "h3", h3 unless h3.nil?
	end

	def assert_title( *args )
		assert_select 'title', build_title( args )
	end

  def login(user)
    activate_authlogic
    UserSession.create user
  end

  def login_user
    user = User.sham!
    login( user )
    user
  end

  def login_admin
    user = User.sham!( :admin )
    login( user )
    user
  end

  def login_artist_user
    membership = Membership.sham!
    login( membership.user )
    membership
  end

  def allow(action, subject, scope = nil)
    activate_authlogic
    unless @controller.abilities.class == TestAbility
      @controller.abilities = TestAbility.new
    end
    @controller.abilities.allow(action, subject, scope)
  end

  def deny(action, subject)
    activate_authlogic
    @controller.abilities = TestAbility.new
  end

  def assert_authorized(action, subject, scope = nil, &block)
    activate_authlogic
    @controller.abilities = TestAbility.new
    assert_raises User::AccessDenied do
      block.call
    end
    @controller.abilities.allow(action, subject, scope)
    assert_nothing_raised User::AccessDenied do
      block.call
    end
  end
end

