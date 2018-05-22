class GdprConsentsController < ApplicationController
  skip_before_action :check_gdpr_consent
  def new
  end

  def create
    current_user.update(gdpr_consent_given_on: Time.zone.now)
    redirect_to '/'
  end
end
