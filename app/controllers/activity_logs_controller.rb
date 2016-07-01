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
      ActivityLogMailer.liked(@activity_log, current_user).deliver_now
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
    @activity_log = ActivityLog.new(params[:activity_log])
    @activity_log.user_id = current_user.id
    @activity_log.participation_id = params[:participation_id]
    if @activity_log.save
      redirect_to [@activity_log.challenge, @activity_log.participation], notice: "Activity logged!"
    else
      render :new
    end
  end

  def update
    @activity_log = current_user.activity_logs.find(params[:id])
    if @activity_log.update(params[:activity_log])
      redirect_to [@activity_log.challenge, @activity_log.participation], notice: "Activity updated!"
    else
      render :edit
    end
  end

  def destroy
    destroy! {  url_for [@activity_log.challenge, @activity_log.participation] }
  end
end
