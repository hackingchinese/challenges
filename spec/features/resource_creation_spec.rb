require "spec_helper"
describe 'Resource creation', js: true do
  let(:user1) { Fabricate :user, name: 'user1', email: 'info1@foobar.com', password: 'password123', created_at: 1.year.ago }
  let(:user2) { Fabricate :user, name: 'user2', email: 'info2@foobar.com', password: 'password123', created_at: 1.year.ago }

  specify 'Resource creation + User inform' do
    Resources::Tag.create(tier: 'level', name: 'Beginner')
    Resources::Tag.create(tier: 'topic', name: 'Listening')
    user1.mail_preference.update(new_resource: '1', created_at: 1.week.ago)
    user2.mail_preference.update(new_resource: '1', created_at: 1.week.ago)

    in_browser 'user1' do
      login user1.email, 'password123'
      visit '/resources'
      click_on 'Submit'
      fill_in 'Url', with: 'http://www.hackingchinese.com/best-twitter-feeds-learning-chinese-2016/'
      fill_in 'Title', with: 'blablablablablabla'
      fill_in 'Description', with: 'asdads asdasda dasd asdasd asdasdasd'
      sleep 0.2

      first('.select2').click
      first('.select2-results li', text: 'Beginner').click
      all('.select2')[1].click
      first('.select2-results li', text: 'Listening').click
      click_on 'Submit story'
      expect(page).to have_content "Resource created"
      expect(Resources::Story.first.likes.count).to be == 1
    end
    expect(ActionMailer::Base.deliveries.count).to be == 1
    in_browser 'user2' do
      login user2.email, 'password123'
      visit '/resources'
      find('.fa-commenting-o').click
      if !page.has_content?("Leave a comment")
        find('.fa-commenting-o').click
      end
      expect(page).to have_content 'Leave a comment'
      find('.fa-heart-o').click
      fill_in 'resources_comment[comment]', with: "Thx"
      click_on 'Send'
      expect(page).to have_content 'Comment created'
    end
    expect(ActionMailer::Base.deliveries.count).to be == 2
  end

end
