require "spec_helper"
describe 'Challenge', js: true do

  let(:user) { Fabricate :user, email: 'info@foobar.com', password: 'password123' }

  specify 'Participate - Time Challenge' do
    challenge = Fabricate :challenge, title: 'Spring break'
    login user.email, 'password123'

    expect(page).to have_content 'Spring break'
    click_on 'Enroll!'
    fill_in 'hours', with: 50
    click_on 'Take part'

    click_on 'Report progress'
    fill_in 'Minutes', with: '600'
    fill_in 'Comment', with: 'Very good!'
    click_on 'Log'

    expect(page).to have_content 'successful'
    ActivityLog.first.tap do |al|
      expect(al.hours_spent).to be == 10.0
      expect(al.minutes).to be == 600
      expect(al.score).to be == 10
      expect(al.comment).to be == 'Very good!'
      expect(al.user).to be == user
      expect(al.participation).to be_present
      expect(al.challenge).to be == challenge
    end

    click_on 'View your statistics'
    expect(page).to have_content '20.0%'

    visit '/'
    click_on 'Spring break'
    expect(page).to have_content '1.'
    expect(page).to have_content 'Stefan'
  end

  specify 'Participate - Unit Challenge' do
    challenge = Fabricate :reading_challenge, title: 'Spring break II'
    expect(challenge.running?).to eql true
    login user.email, 'password123'
    click_on 'Enroll!'
    fill_in 'pages', with: 50
    click_on 'Take part'
    click_on 'Report progress'

    fill_in 'pages', with: '5'
    click_on 'Optional: Please report'
    fill_in 'Minutes', with: 60
    fill_in 'Comment', with: 'Very good!'
    click_on 'Log'
    expect(page).to have_content 'successful'
    ActivityLog.first.tap do |al|
      expect(al.hours_spent).to be == 1.0
      expect(al.minutes).to be == 60
      expect(al.score).to be == 5
      expect(al.comment).to be == 'Very good!'
      expect(al.user).to be == user
      expect(al.participation).to be_present
      expect(al.challenge).to be == challenge
    end
    click_on 'View your statistics'
    expect(page).to have_content '10.0%'
  end

  specify 'Can participate in a challenge that is not started yet, but cant log anything' do
    challenge = Fabricate :reading_challenge, title: 'Spring break II', from_date: 7.days.from_now, to_date: 27.days.from_now
    expect(Challenge.upcoming_or_running).to include challenge
    expect(challenge.running?).to be false

    login user.email, 'password123'

    click_on 'Enroll!'
    fill_in 'pages', with: 50
    click_on 'Take part'

    expect(page).to_not have_content 'Report progress'
  end
end
