ENV["RAILS_ENV"] ||= 'test'
require 'pludoni_rspec'
PludoniRspec.run

require 'email_spec'

RSpec.configure do |config|
  # config.example_status_persistence_file_path = '.rspec.failed.txt'
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  # config.order = "random"

  # config.use_transactional_fixtures = false
  config.backtrace_exclusion_patterns << %r{/gems/}
end
