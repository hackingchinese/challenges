class ChallengesController < InheritedResources::Base
  load_and_authorize_resource
  def permitted_params
    params.permit!
  end
end
