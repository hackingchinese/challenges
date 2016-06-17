class CommentsController < ApplicationController
  authorize_resource class: 'ActivityLog::Comment'

  def create
    @activity_log = ActivityLog.find params[:activity_log_id]
    @comment = ActivityLog::Comment.new(params[:comment].permit(:text))
    @comment.activity_log_id = params[:activity_log_id]
    @comment.user_id = current_user.id
    if @comment.save
      CommentCreation.new(@comment).send_notifications(current_user)

      redirect_to [ @activity_log.challenge, @activity_log.participation], notice: "Comment created."
    else
      render text: "No Text specified", layout: true
    end
  end
end
