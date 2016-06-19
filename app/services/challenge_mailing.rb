class ChallengeMailing
  class << self
    def cronjob
      Challenge.visible.upcoming_or_running.where('from_date >= ?', Date.today).each do |challenge|
        case (challenge.from_date - Date.today).round
        when 3
          users.find_each do |user|
            ChallengeMailer.starts_soon(challenge, user).deliver_now
          end
        when 0
          users.find_each do |user|
            ChallengeMailer.started(challenge, user).deliver_now
          end
        end
      end
    end

    def users
      User.with_email
    end
  end
end
