require "spec_helper"
describe 'Challenge', js: true do

  let(:user) { Fabricate :user, email: 'info@foobar.com', password: 'password123' }

  specify 'Participate - Time Challenge' do
    challenge = Fabricate :challenge, title: 'Spring break'
    login user.email, 'password123'

    page.should have_content 'Spring break'
    click_on 'Enroll!'
    fill_in 'hours', with: 50
    click_on 'Take part'

    click_on 'Report progress'
    fill_in 'Minutes', with: '600'
    fill_in 'Comment', with: 'Very good!'
    click_on 'Log'

    page.should have_content 'successful'
    ActivityLog.first.tap do |al|
      al.hours_spent.should == 10.0
      al.minutes.should == 600
      al.score.should == 10
      al.comment.should == 'Very good!'
      al.user.should == user
      al.participation.should be_present
      al.challenge.should == challenge
    end

    click_on 'View your statistics'
    page.should have_content '20.0%'

    visit '/'
    click_on 'Spring break'
    page.should have_content '1.'
    page.should have_content 'Stefan'
  end

  specify 'Participate - Unit Challenge' do
    challenge = Fabricate :reading_challenge, title: 'Spring break II'
    challenge.running?.should be_true
    login user.email, 'password123'
    click_on 'Enroll!'
    fill_in 'pages', with: 50
    click_on 'Take part'
    click_on 'Report progress'

    fill_in 'pages', with: '5'
    click_on 'Optional'
    fill_in 'Minutes', with: 60
    fill_in 'Comment', with: 'Very good!'
    click_on 'Log'
    page.should have_content 'successful'
    ActivityLog.first.tap do |al|
      al.hours_spent.should == 1.0
      al.minutes.should == 60
      al.score.should == 5
      al.comment.should == 'Very good!'
      al.user.should == user
      al.participation.should be_present
      al.challenge.should == challenge
    end
    click_on 'View your statistics'
    page.should have_content '10%'
  end

  specify 'Can participate in a challenge that is not started yet, but cant log anything' do
    challenge = Fabricate :reading_challenge, title: 'Spring break II', from_date: 7.days.from_now, to_date: 27.days.from_now
    Challenge.upcoming_or_running.should include challenge
    challenge.should_not be_running

    login user.email, 'password123'

    click_on 'Enroll!'
    fill_in 'pages', with: 50
    click_on 'Take part'

    page.should_not have_content 'Report progress'
  end
end
