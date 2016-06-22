class Resources::CommentsController < ApplicationController
  authorize_resource

  def create
    @story = Resources::Story.find(params[:story_id])
    @comment = Resources::Comment.new(comment: params[:resources_comment][:comment])
    @comment.user = current_user
    @comment.story = @story
    if @comment.save
      @story.notify_new_comment(@comment)
      redirect_to resources_story_path(@comment.story), notice: "Comment created."
    else
      flash.now[:alert] = "Please enter a comment text."
      render 'resources/stories/show'
    end
  end
end
