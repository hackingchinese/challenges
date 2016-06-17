class MailPreference < ActiveRecord::Base
  belongs_to :user

  MAILS = [
    :liked_disabled,
    :commented_disabled,
    :comment_on_watched_thread_disabled,
    :challenge_starts_soon_disabled,
    :challenge_started_disabled,
  ]
  MAILS.each do |mail|
    store_accessor :mails_disabled, mail
  end

  def self.allowed?(user, mail_type)
    mp = MailPreference.where(user_id: user.id).first
    return true if !mp
    key = "#{mail_type}_disabled"
    if !MAILS.include?(key.to_sym)
      raise ArgumentError.new("Unknown mail type: #{key}")
    end
    value = mp.mails_disabled[key]
    value != "1"
  end

end
