class ActivityLogMailer < ActionMailer::Base
  default from: 'challenges@hackingchinese.com'

  def liked(activity_log, liked_by_user)
    @activity_log = activity_log
    @user = activity_log.user
    @liked_by = liked_by_user
    mail to: @user.email,
      subject: "[Hackingchinese] one of your activities was liked by #{liked_by_user.name}"
  end

  def commented(activity_log, comment)
    return if comment.user == activity_log.user
    @comment = comment
    @activity_log = activity_log
    @user = activity_log.user

    mail to: @user.email,
      subject: "[Hackingchinese] one of your activities was commented by #{comment.user.name}"
  end
end
