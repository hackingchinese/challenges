class ActivityLogsController < ApplicationController
  before_action do
    headers['Cache-Control'] = 'no-cache, max-age=0, must-revalidate, no-store'
    @participation = Participation.find(params[:participation_id])
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to [@activity_log.challenge, @activity_log.participation], alert: "Sorry, this action was cancelled, because the the form was open to long, please try again!"
  end

  def new
    date = Time.zone.now.to_date
    if date > @participation.challenge.to_date
      date = @participation.challenge.to_date
    end
    @activity_log = ActivityLog.new
    @activity_log.participation = @participation
    @activity_log.date = date
    authorize! :new, @activity_log
  end

  def toggle_like
    @activity_log = ActivityLog.find(params[:id])
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
    @activity_log.participation = @participation
    authorize! :create, @activity_log
    if @activity_log.save
      redirect_to [@activity_log.challenge, @participation], notice: "Activity logged!"
    else
      render :new
    end
  end

  def edit
    @activity_log = ActivityLog.find(params[:id])
    authorize! :edit, @activity_log
  end

  def update
    @activity_log = current_user.activity_logs.find(params[:id])
    authorize! :update, @activity_log
    if @activity_log.update(params[:activity_log])
      redirect_to [@activity_log.challenge, @activity_log.participation], notice: "Activity updated!"
    else
      render :edit
    end
  end

  def destroy
    @activity_log = ActivityLog.find(params[:id])
    authorize! :destroy, @activity_log
    @activity_log.destroy
    redirect_to [@activity_log.challenge, @activity_log.participation], notice: "Activity removed!"
  end
end
