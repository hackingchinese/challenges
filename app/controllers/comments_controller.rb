class CommentsController < ApplicationController
  authorize_resource class: 'ActivityLog::Comment'

  def new
  end

  def create
    @activity_log = ActivityLog.find params[:activity_log_id]
    @comment = ActivityLog::Comment.new(params[:comment].permit(:text))
    @comment.activity_log_id = params[:activity_log_id]
    @comment.user_id = current_user.id
    if @comment.save
      # TODO Mail an alle beteiligten ausser dem der schreibt
      ActivityLogMailer.commented(@activity_log, @comment).deliver

      redirect_to [ @activity_log.challenge, @activity_log.participation], notice: "Comment created."
    else
      render text: "No Text specified", layout: true
    end
  end
end
