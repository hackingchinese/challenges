class MailPreferencesController < ApplicationController
  authorize_resource class: false
  before_action :check_gdpr_consent

  def edit
    @mail_preference = current_user.mail_preference || current_user.create_mail_preference(mails_enabled: {})
  end

  def update
    @mail_preference = current_user.mail_preference || current_user.create_mail_preference
    @mail_preference.update(params[:mail_preference].permit(*MailPreference::MAILS))
    flash.now[:notice] = "Settings saved."
    render :edit
  end
end
