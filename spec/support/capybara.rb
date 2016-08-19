require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist
Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.before(:each, js: true) do
    page.driver.browser.url_blacklist = [
      "http://fonts.googleapis.com",
      "http://fonts.gstatic.com",
      "http://fonts.useso.com"
    ]
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

  def screenshot(name='foo')
    page.save_screenshot "#{name}.png", full: true
  end
end
