class ParticipationsController < InheritedResources::Base
  belongs_to :challenge
  authorize_resource

  def permitted_params
    {
      participation: params.require(:participation).
      merge(user_id: @participation.try(:user_id) || current_user.id).
      permit(:goal_hours, :goal_units, :user_id)
    }
  end

end
