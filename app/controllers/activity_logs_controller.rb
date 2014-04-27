class ActivityLogsController < InheritedResources::Base
  belongs_to :participation
  load_and_authorize_resource
  def permitted_params
    {
      activity_log: params.permit(:activity_log).merge(user_id: @activity_log.try(:user_id) || current_user.id).permit(:hours_spent, :hours_measure, :units_accomplished, :units_measure, :comment, :user_id)
    }
  end
end
