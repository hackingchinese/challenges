class ChallengeMailer < ActionMailer::Base
  default from: 'challenges@hackingchinese.com'

  def starts_soon(challenge, user)
    @challenge = challenge
    @user = user
    return if !MailPreference.allowed?(@user, :challenge_starts_soon)
    mail to: user.email,
      subject: "[Hackingchinese] #{challenge.title} starts soon"
  end

  def started(challenge, user)
    @challenge = challenge
    @user = user
    return if !MailPreference.allowed?(@user, :challenge_started)
    mail to: user.email,
      subject: "[Hackingchinese] #{challenge.title} just started!"
  end
end
