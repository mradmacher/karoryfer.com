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

Release::Uploader.album_store_dir = "/tmp"
Release::Uploader.track_store_dir = "/tmp"
Attachment::Uploader.store_dir = "/tmp"
Track::Uploader.store_dir = "/tmp"
Releaser::Base.publisher_name = 'Lecolds'
Releaser::Base.publisher_host = 'www.lecolds.com'

class ActiveSupport::TestCase
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
end

