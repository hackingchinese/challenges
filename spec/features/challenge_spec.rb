require "spec_helper"
describe 'Challenge', js: true do

  specify 'Participate' do
    Fabricate :user, email: 'info@foobar.com', password: 'password123'
    Fabricate :challenge, title: 'Spring break'
    login 'info@foobar.com', 'password123'

    page.should have_content 'Spring break'
    click_on 'Enroll!'

  end
end
