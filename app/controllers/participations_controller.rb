class ParticipationsController < InheritedResources::Base
  belongs_to :challenge
  authorize_resource

  def new
    new! do
      @participation.goal_hours = 10
    end
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

  def update
    @participation = current_user.participations.find(params[:id])
    if @participation.update(params[:participation])
      redirect_to [@participation.challenge, @participation], notice: "Goal updated!"
    else
      render :edit
    end
  end

end
