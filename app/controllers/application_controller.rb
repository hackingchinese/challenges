class ApplicationController < ActionController::Base
  before_action :block_ie
  def block_ie
    if request.user_agent.to_s =~ /MSIE|Trident/
      render plain: "Your browser is not supported anymore.", status: 406
    end
  end

  before_action do
    @site_title = (Rails.env.development? ? "(DEV) " : "") + 'HC Challenges'
    @page_description = 'Hacking Chinese Challenges - building language skills through daily practice and friendly competition!'
    @page_title = "Building language skills through daily practice and friendly competition!"
  end

  include ActiveParams
  include SimpleCaptcha::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.warn "CANCAN: #{exception.subject} #{exception.action}"
    redirect_to main_app.root_url, :alert => exception.message
  end
  rescue_from ActionController::BadRequest do |exception|
    render plain: "Please stop. It's not working", status: 410
  end
  before_action do
    if request.host == 'resources.hackingchinese.com'
      if request.env['REQUEST_URI'] == '/'
        url = 'http://challenges.hackingchinese.com/resources'
      else
        url = "http://challenges.hackingchinese.com" + request.env['REQUEST_URI']
      end
      redirect_to url
    end
  end

  before_action :check_valid_email
  before_action :check_gdpr_consent

  def check_valid_email
    if current_user && current_user.fake_email?
      @fake_email = true
    end
  end

  def check_gdpr_consent
    if current_user && !current_user.gdpr_consent_given_on
      redirect_to new_gdpr_consent_path
    end
  end

  def navigation_name
    'challenges'
  end
  helper_method :navigation_name

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?

  def current_participation
    @current_participation ||=
      @participation || (@challenge && @challenge.participations.find_by(user_id: current_user.try(:id)))
  end
  helper_method :current_participation

  def append_info_to_payload(payload)
    super
    payload[:ip] = request.remote_ip
  end
end
