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
    check 'I have read'
    click_button 'Sign up'
    expect(page).to have_content 'successfully'

    expect(User.count).to eql 1
    User.first.tap do |user|
      expect(user.email).to eql 'info@stefanwienert.de'
      expect(user.role).to be_nil
      expect(user.avatar).to be_present
      expect(user.gdpr_consent_given_on).to be >= 1.day.ago
    end

    logout!
  end

  specify 'Login' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    expect(page).to have_content 'successfully'

    logout!
  end

  specify 'change password' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    login 'info@foobar.com', 'password123'
    click_on 'Stefan'
    click_on 'Edit account'
    fill_in 'Profile link', with: 'http://www.stefanwienert.de'
    click_on 'Change password'
    fill_in 'user[password]', with: 'newpassword'
    fill_in 'user[password_confirmation]', with: 'newpassword'
    click_on 'Save'
    if !page.has_content? 'successfully'
      click_on 'Save'
    end
    expect(page).to have_content 'successfully'
    expect(User.first.profile_link).to eql 'http://www.stefanwienert.de'
    expect(User.first.valid_password?('newpassword')).to eql true
  end

  def logout!
    click_on 'Stefan'
    expect(page).to have_content 'Logout'
    expect(page).to have_content 'successfully'
  end
end
