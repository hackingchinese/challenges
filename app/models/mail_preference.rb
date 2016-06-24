class MailPreference < ActiveRecord::Base
  belongs_to :user

  MAILS = [
    :liked_disabled,
    :commented_disabled,
    :comment_on_watched_thread_disabled,
    :challenge_starts_soon_disabled,
    :challenge_started_disabled,

    :new_resource_disabled,
    :resource_comment_on_story_disabled,
    :resource_comment_on_thread_disabled,
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

  def self.notifiable_users(mail_type)
    mail_type = mail_type.to_s + "_disabled"
    MailPreference.
      where("mails_disabled is not null and (mails_disabled->?) is not null", mail_type).
      where("(mails_disabled->>?) = ?", mail_type, '0').map(&:user)
  end

end
