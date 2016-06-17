class ParticipationsController < InheritedResources::Base
  belongs_to :challenge
  authorize_resource

  def new
    new! do
      @participation.goal_hours = 10
    end
  end

  def permitted_params
    para = params.permit(:participation => [:goal_units, :goal_hours])
    user_id = @participation.try(:user_id) || current_user.id
    para[:participation] and para[:participation].merge!(user_id: user_id, challenge_id: @challenge.id)
    para
  end

end
