require 'spec_helper'

describe ChallengeMailing do
  after(:each) do
    Timecop.return
    ActionMailer::Base.deliveries.clear
  end
  specify 'Sends out reminder 3 days ahead' do
    challenge = Fabricate(:challenge, from_date: '2015-05-15', to_date: '2015-06-15', link: 'http://www.foobar.com')
    user = Fabricate(:user, email: 'info@stefanwienert.de', name: 'stefan w')

    Timecop.freeze '2015-05-10 17:00:00' # 5 days ahead
    ChallengeMailing.cronjob
    expect(ActionMailer::Base.deliveries.count).to be == 0

    Timecop.travel '2015-05-12 17:00:00' # 3 days ahead
    ChallengeMailing.cronjob
    expect(ActionMailer::Base.deliveries.count).to be == 1
    ActionMailer::Base.deliveries.first.tap do |mail|
      expect(mail.subject).to include challenge.title
      expect(mail.to.first).to be == user.email
      expect(mail.body.to_s).to include user.name
    end

    Timecop.travel '2015-05-13 17:00:00' # 2 days ahead
    expect { ChallengeMailing.cronjob }.not_to change(ActionMailer::Base.deliveries, :count)
    Timecop.travel '2015-05-14 17:00:00' # 1 days ahead
    expect { ChallengeMailing.cronjob }.not_to change(ActionMailer::Base.deliveries, :count)

    Timecop.travel '2015-05-15 17:00:00' # there
    expect { ChallengeMailing.cronjob }.to change(ActionMailer::Base.deliveries, :count)
    ActionMailer::Base.deliveries.last.tap do |mail|
      expect(mail.subject).to include challenge.title
      expect(mail.to.first).to be == user.email
      expect(mail.body.to_s).to include user.name
    end
  end

  specify 'time is not that important' do
    Fabricate(:challenge, from_date: '2015-05-15', to_date: '2015-06-15', link: 'http://www.foobar.com')
    Fabricate(:user, email: 'info@stefanwienert.de', name: 'stefan w')

    Timecop.freeze '2015-05-12 02:00:00' # 3 days ahead
    ChallengeMailing.cronjob
    expect(ActionMailer::Base.deliveries.count).to be == 1
  end
end
