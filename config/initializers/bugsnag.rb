# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = ENV['KARORYFER_BUGSNAG_API_KEY']
end
