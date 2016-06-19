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
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.use_transactional_fixtures = false
  config.backtrace_exclusion_patterns << %r{/gems/}
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each, js: true) do
    page.driver.browser.url_blacklist = ["http://fonts.googleapis.com",  "http://fonts.useso.com"]
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
    expect(page).to have_content 'successfully'
  end
  def in_browser(name)
    old_session = Capybara.session_name
    Capybara.session_name = name
    yield
    Capybara.session_name = old_session
  end
end
