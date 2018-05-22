class ChallengesController < ApplicationController
  load_and_authorize_resource
  before_action :check_gdpr_consent

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
    @offset = 0
    @max = [ 1 ,@challenge.participations.maximum('score') || 0 ].max
    @page_title = @challenge.title

    @feed = @challenge.activity_feed_items.sorted.page(params[:page]).per(25)
  end

  def edit
  end

  def update
    if @challenge.update(params[:challenge].permit!)
      redirect_to @challenge, notice: "Successfully saved!"
    else
      render :edit
    end
  end

  def destroy
    @challenge.destroy
    redirect_to '/', notice: "Successfully deleted."
  end

end
