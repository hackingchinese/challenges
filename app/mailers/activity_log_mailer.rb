class ActivityLogMailer < ActionMailer::Base
  default from: 'challenges@hackingchinese.com'

  def liked(activity_log, liked_by_user)
    @activity_log = activity_log
    @user = activity_log.user
    @liked_by = liked_by_user
    return if !MailPreference.allowed?(@user, :liked)
    mail to: @user.email,
      subject: "[Hackingchinese] one of your activities was liked by #{liked_by_user.name}"
  end

  def commented(activity_log, comment)
    @comment = comment
    @activity_log = activity_log
    @user = activity_log.user
    return if !MailPreference.allowed?(@user, :commented)

    mail to: @user.email,
      subject: "[Hackingchinese] one of your activities was commented by #{comment.user.name}"
  end

  def comment_on_watched_thread(comment, user)
    @comment = comment
    @activity_log = comment.activity_log
    @user = user
    return if !MailPreference.allowed?(@user, :comment_on_watched_thread)

    mail to: @user.email,
      subject: "[Hackingchinese] one of your comments was replied to by #{comment.user.name}"
  end
end
