class ApplicationController < ActionController::Base
  before_action do
    @site_title = (Rails.env.development? ? "(DEV) " : "") + 'HC Challenges'
    @page_description = 'Hacking Chinese Challenges - building language skills through daily practice and friendly competition!'
    @page_title = "Building language skills through daily practice and friendly competition!"
  end

  def navigation_name
    'challenges'
  end
  helper_method :navigation_name

  include SimpleCaptcha::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.warn "CANCAN: #{exception.subject} #{exception.action}"
    redirect_to main_app.root_url, :alert => exception.message
  end

  before_filter :check_valid_email

  def check_valid_email
    if current_user && current_user.fake_email?
      @fake_email = true
    end
  end

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?

  def current_participation
    @current_participation ||=
      @participation || (@challenge && @challenge.participations.find_by(user_id: current_user.try(:id)))
  end
  helper_method :current_participation

  def resource_params
    permitted_params
  end
end
