class ApplicationController < ActionController::Base

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

  def resource_params
    permitted_params
  end
end
