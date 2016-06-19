class CommentCreation
  def initialize(comment)
    @comment = comment
  end

  def send_notifications(current_user)
    if current_user != @comment.activity_log.user
      ActivityLogMailer.commented(@comment.activity_log, @comment).deliver_now
    end

    other = @comment.activity_log.comments.map(&:user).uniq - [ @comment.user] - [current_user]
    other.each do |user|
      ActivityLogMailer.comment_on_watched_thread(@comment, user).deliver_now
    end
  end
end
