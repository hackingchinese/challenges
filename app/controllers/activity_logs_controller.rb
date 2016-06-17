class ActivityLogsController < InheritedResources::Base
  belongs_to :participation
  load_and_authorize_resource

  def new
    super do
      date = Time.zone.now.to_date
      if date > @participation.challenge.to_date
        date = @participation.challenge.to_date
      end
      @activity_log.date = date
    end
  end

  def toggle_like
    authorize! :like, @activity_log
    existing = @activity_log.likes.where(user_id: current_user.id).first_or_initialize
    if existing.new_record?
      ActivityLogMailer.liked(@activity_log, current_user).deliver
      existing.save
    else
      existing.destroy
    end
    respond_to do |f|
      f.html {
        redirect_to [@activity_log.challenge, @activity_log.participation]
      }
      f.js {
        @body = render_to_string partial: @activity_log, format: 'html'
      }
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

  protected

  def permitted_params
    para = params.permit( :challenge_id, :participation_id, { activity_log: [:minutes, :units_accomplished, :date, :units_measure, :comment, :hours_measure]})

    user_id = @activity_log.try(:user_id) || current_user.try(:id)
    if para[:activity_log]
      para[:activity_log].merge!(user_id: user_id)
      para[:activity_log].merge!(participation_id: params[:participation_id])
    else
      para.merge! user_id: user_id
    end
    para
  end
end
