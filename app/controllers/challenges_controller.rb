class ChallengesController < InheritedResources::Base
  load_and_authorize_resource

  def show
    super do
      @leaderboard = @challenge.leaderboard.page(params[:page]).per(20)
      @offset = ( @leaderboard.current_page - 1 ) * 20
      @max = [ 1 ,@challenge.participations.maximum('score') || 0 ].max
    end
  end

  def permitted_params
    params.permit!
  end
end
