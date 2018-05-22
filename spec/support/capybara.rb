
RSpec.configure do
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

  def screenshot(name = 'foo')
    page.save_screenshot "#{name}.png", full: true
  end
end

# Capybara.asset_host = 'http://localhost:3000'
# Capybara.default_max_wait_time = 10

require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Chromedriver.set_version "2.36"

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    'chromeOptions' => {
      args: %w(headless disable-gpu window-size=1600,1200 no-sandbox)
    }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

RSpec.configure do |c|
  c.before(:each, js: true) do |_ex|
    Capybara.default_max_wait_time = 60 if ENV['CI']
    if !@headless and RbConfig::CONFIG['host_os']['linux']
      @headless = Headless.new(destroy_at_exit: true, reuse: true)
      @headless.start
    end
  end
end

Capybara.javascript_driver = :headless_chrome
