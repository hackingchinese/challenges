class Resources::Mailer < ActionMailer::Base
  default from: 'challenges@hackingchinese.com'
  helper :application

  def new_comment(comment, user)
    @story = comment.story
    @user = user
    @comment = comment

    if user == @story.user
      return if !MailPreference.allowed?(@user, :resource_comment_on_story)
      mail to: @user.email, subject: "[Hackingchinese] New comment on one of your stories \"#{@story.title}\""
    else
      return if !MailPreference.allowed?(@user, :resource_comment_on_thread)
      mail to: @user.email, subject: "[Hackingchinese] New comment on a story you commented on"
    end
  end
end
