class UsersController < ApplicationController
  before_action do
    @user = User.find(params[:id])
  end

  def show
    @participations = @user.participations.includes(:challenge).references(:challenge).order('challenges.from_date desc').select{|i| i.challenge.present?}
  end

  def liked
    @resources_liked = Resources::Story.joins(:likes).
      where(resources_likes: { user_id: @user.id }).
      where.not(user_id: @user.id).
      includes(:tags, :user).
      order('resources_likes.created_at desc').
      page(params[:like_page]).per(18)

  end

  def submissions
    @resources = @user.stories.
      includes(:tags, :user).
      order('like_count desc').
      page(params[:story_page]).per(18)
  end
end
