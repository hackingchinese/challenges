class MailPreference < ApplicationRecord
  belongs_to :user
  before_create :set_defaults

  MAILS = [
    :liked,
    :commented,
    :comment_on_watched_thread,
    :challenge_starts_soon,
    :challenge_started,

    :new_resource,
    :resource_comment_on_story,
    :resource_comment_on_thread,
  ]
  MAILS.each do |mail|
    store_accessor :mails_enabled, mail
  end

  def disable!
    MAILS.each do |mail|
      self.send("#{mail}=", '0')
    end
    save
  end

  def set_defaults
    self.liked = '1' if liked.nil?
    self.commented = '1' if commented.nil?
    self.comment_on_watched_thread = '1' if comment_on_watched_thread.nil?
    self.challenge_starts_soon = '1' if challenge_starts_soon.nil?
    self.challenge_started = '1' if challenge_started.nil?
    self.resource_comment_on_story = '1' if resource_comment_on_story.nil?
    self.resource_comment_on_thread = '1' if resource_comment_on_thread.nil?
  end

  def self.allowed?(user, key)
    return false if user.email.include? '@changeme' or user.email.blank?
    mp = MailPreference.where(user_id: user.id).first
    return true if !mp
    if !MAILS.include?(key.to_sym)
      raise ArgumentError.new("Unknown mail type: #{key}")
    end
    mp.mails_enabled[key.to_s] == '1'
  end

  def self.notifiable_users(mail_type)
    mail_type = mail_type.to_s
    MailPreference.
      where("mails_enabled is not null and (mails_enabled->?) is not null", mail_type).
      where("(mails_enabled->>?) = ?", mail_type, '1').map(&:user)
  end

end
