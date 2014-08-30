class ActivityLogsController < InheritedResources::Base
  belongs_to :participation
  load_and_authorize_resource

  def permitted_params
    para = params.permit( :challenge_id, :participation_id, { activity_log: [:minutes, :units_accomplished, :date, :units_measure, :comment, :hours_measure]})

    user_id = @activity_log.try(:user_id) || current_user.id
    if para[:activity_log]
      para[:activity_log].merge!(user_id: user_id)
      para[:activity_log].merge!(participation_id: params[:participation_id])
    else
      para.merge! user_id: user_id
    end
    para
  end

  def new
    super do
      @activity_log.date = Time.zone.now.to_date
    end
  end

  def create
    create! {  url_for [@activity_log.challenge, @activity_log.participation] }
  end

  def update
    update! {  url_for [@activity_log.challenge, @activity_log.participation] }
  end

  def destroy
    destroy! {  url_for [@activity_log.challenge, @activity_log.participation] }
  end
end
