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
    page.should have_content 'successfully'

    User.count.should == 1
    User.first.tap do |user|
      user.email.should == 'info@stefanwienert.de'
      user.role.should be_nil
      user.avatar.should be_present
    end

    logout!
  end

  specify 'Login' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    page.should have_content 'successfully'

    logout!
  end

  specify 'edit account' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    click_on 'Stefan'
    click_on 'Edit account'
    fill_in 'Profile link', with: 'http://www.stefanwienert.de'
    click_on 'Update'
    page.should have_content 'successfully'
    User.first.profile_link.should == 'http://www.stefanwienert.de'
  end

  specify 'change password' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    click_on 'Stefan'
    click_on 'Edit account'
    click_on 'Change password'
    fill_in 'user[password]', with: 'newpassword'
    fill_in 'user[password_confirmation]', with: 'newpassword'
    click_on 'Update'
    page.should have_content 'successfully'
    User.first.valid_password?('newpassword').should == true
  end

  def logout!
    click_on 'Stefan'
    page.should have_content 'Logout'
    page.should have_content 'successfully'

  end

end
