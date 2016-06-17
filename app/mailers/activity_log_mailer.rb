class ActivityLogMailer < ActionMailer::Base
  default from: 'challenges@hackingchinese.com'

  def liked(activity_log, liked_by_user)
    @activity_log = activity_log
    @user = activity_log.user
    @liked_by = liked_by_user
    mail to: @user.email,
      subject: "[Hackingchinese] one of your activity was liked by #{liked_by_user.name}"
  end
end
