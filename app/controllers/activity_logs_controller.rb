class ActivityLogsController < InheritedResources::Base
  belongs_to :participation
  belongs_to :current_user
  load_and_authorize_resource
  def permitted_params
    params.permit!
  end
end
