require "spec_helper"
describe 'Registration', js: true do

  specify 'default registration' do
    visit '/'
    within 'main' do
      click_on 'Sign Up'
    end
    fill_in 'Name', with: 'Stefan'
    fill_in 'Email', with: 'info@stefanwienert.de'
    fill_in 'user[password]', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    click_button 'Sign up'
    save_screenshot 'public/screenshot.jpg'
    page.should have_content 'successfully'

    User.count.should == 1
    User.first.tap do |user|
      user.email.should == 'info@stefanwienert.de'
      user.role.should be_nil
      user.avatar.should be_present
    end

    click_on 'Logout'
    page.should have_content 'successfully'
  end

  specify 'Login' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    page.should have_content 'successfully'
    page.should have_content 'Logout'

  end

end
