class ChallengesController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    @challenge = Challenge.new(params[:challenge])
    if @challenge.save
      redirect_to @challenge, notice: "Challenge created"
    else
      render :new
    end
  end

  def show
    @leaderboard = @challenge.leaderboard
    # @offset = ( @leaderboard.current_page - 1 ) * 20
    @offset = 0
    @max = [ 1 ,@challenge.participations.maximum('score') || 0 ].max
    @page_title = @challenge.title
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
