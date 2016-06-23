class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @participations = @user.participations.includes(:challenge).references(:challenge).order('challenges.from_date desc').select{|i| i.challenge.present?}
    @resources_liked = Resources::Story.joins(:likes).
      where(resources_likes: { user_id: @user.id }).
      where.not(user_id: @user.id).
      includes(:tags, :user).
      order('resources_likes.created_at desc').
      page(params[:like_page]).per(18)

    @resources = @user.stories.
      includes(:tags, :user).
      order('like_count desc').
      page(params[:story_page]).per(18)
  end
end
