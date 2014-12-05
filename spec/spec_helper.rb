ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'webmock/rspec'
require 'payload/testing'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Features, type: :feature
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.infer_base_class_for_anonymous_controllers = true
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!
  config.order = :random
  config.use_transactional_fixtures = false

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.before(:each, js: true) do
    page.driver.browser.url_blacklist = [
      "http://cloud.typography.com",
      "http://stats.pusher.com"
    ]
  end

  config.include Payload::Testing
end

Capybara.javascript_driver = :webkit
WebMock.disable_net_connect!(allow_localhost: true)
