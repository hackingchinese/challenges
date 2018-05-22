class ParticipationsController < ApplicationController
  authorize_resource
  before_action do
    @challenge = Challenge.find params[:challenge_id]
  end

  def show
    @participation = Participation.find(params[:id])
  end

  def new
    @participation = Participation.new
    @participation.goal_hours = 10
  end

  def create
    @participation = Participation.new(params[:participation])
    @participation.user_id = current_user.id
    @participation.challenge_id = params[:challenge_id]
    if @participation.save
      redirect_to [@participation.challenge, @participation], notice: "You are now taking part!"
    else
      render :new
    end
  end

  def edit
    @participation = Participation.find(params[:id])
    authorize! :edit, @participation
  end

  def update
    @participation = current_user.participations.find(params[:id])
    if @participation.update(params[:participation])
      redirect_to [@participation.challenge, @participation], notice: "Goal updated!"
    else
      render :edit
    end
  end

  def destroy
    @participation = Participation.find(params[:id])
    c = @participation.challenge
    authorize! :destroy, @participation
    redirect_to c, notice: "Left the challenge"
  end
end
