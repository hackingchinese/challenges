RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do |example|
    ActionMailer::Base.deliveries.clear
    ex = defined?(example.example) ? example.example : example
    DatabaseCleaner.strategy = ex.metadata[:js] ? :deletion : :transaction
    DatabaseCleaner.start
  end
  config.after :each do |example|
    DatabaseCleaner.clean
  end
end
