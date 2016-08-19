require "spec_helper"
describe 'Social interactions', js: true do

  let(:user1) { Fabricate :user, name: 'user1', email: 'info1@foobar.com', password: 'password123' }
  let(:user2) { Fabricate :user, name: 'user2', email: 'info2@foobar.com', password: 'password123' }


  specify 'Like + Comment' do
    Fabricate :challenge, title: 'Spring break'
    in_browser 'user1' do
      login user1.email, 'password123'
      expect(page).to have_content 'Spring break'
      click_on 'Enroll!'
      fill_in 'hours', with: 50
      click_on 'Take part'
      all('a', text: 'Report progress').first.click
      fill_in 'Minutes', with: '600'
      fill_in 'Comment', with: 'Used some material from the site'
      click_on 'Log activity'
    end

    in_browser 'user2' do
      login user2.email, 'password123'
      click_on 'Spring break'
      click_on 'Leaderboard'
      click_on 'user1'
      find('.fa-heart-o').click
      expect(page).to have_selector '.fa-heart'
      expect(page).to have_content 'Liked by'

      find('.fa-commenting-o').click
      fill_in 'Comment', with: 'What material did you use?'
      click_on 'Send'
      expect(page).to have_content "Comment created"
      expect(page).to have_content "What material did you use"
    end

    in_browser "user1" do
      ActionMailer::Base.deliveries.last.tap do |mail|
        expect(mail.to).to be == [ user1.email ]
        expect(mail.body.to_s).to include "What material did you use"
      end
      path = URI.parse(Nokogiri::HTML.fragment(ActionMailer::Base.deliveries.last.body.to_s).at('a')['href']).path
      visit path

      expect(page).to have_content 'Liked by'
      expect(page).to have_content "What material did you use"
      find('.fa-commenting-o').click
      fill_in 'Comment', with: 'I used my graded reader blar'
      click_on 'Send'
      expect(page).to have_content "Comment created"
      ActionMailer::Base.deliveries.last.tap do |mail|
        expect(mail.to).to be == [ user2.email ]
        expect(mail.body.to_s).to include "I used my graded reader"
      end
    end
  end
end

