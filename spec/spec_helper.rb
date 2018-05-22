ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require 'active_support'
ActiveSupport::Deprecation.debug = true if ENV['DEBUG']
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec.failed.txt'
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.use_transactional_fixtures = false
  config.backtrace_exclusion_patterns << %r{/gems/}
end
