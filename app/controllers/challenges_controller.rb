class ChallengesController < InheritedResources::Base
  load_and_authorize_resource

  def show
    super do
      @leaderboard = @challenge.leaderboard
      # @offset = ( @leaderboard.current_page - 1 ) * 20
      @offset = 0
      @max = [ 1 ,@challenge.participations.maximum('score') || 0 ].max
      @page_title = @challenge.title
    end
  end

  def permitted_params
    params.permit!
  end
end
