# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
ActiveRecord::Migration.maintain_test_schema!
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    ex = defined?(example.example) ? example.example : example
    DatabaseCleaner.strategy = ex.metadata[:js] ? :deletion : :transaction
    DatabaseCleaner.start
  end
  config.after :each do |example|
    DatabaseCleaner.clean
  end
  def login(username, password)
    visit '/'
    within 'main' do
      click_on 'Sign In'
    end
    fill_in 'Email', with: username
    fill_in 'Password', with: password
    click_on 'Log in'
    page.should have_content 'successfully'
  end
end
# RSpec.configure do |config|
#   config.after :each, js: true do |example|
#     ex = defined?(example.example) ? example.example : example # rspec 2.14...
#     exception = ex.exception
#     if exception.present?
#       puts "made screenshot to /error.jpg (#{exception.inspect})"
#       save_screenshot "public/error.jpg", full: true
#     end
#   end
# end
