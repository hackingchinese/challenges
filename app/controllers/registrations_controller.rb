class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u|
      u.permit(:name, :avatar, :email, :password, :password_confirmation, :profile_link, :no_mails)
    }
    devise_parameter_sanitizer.permit(:account_update){ |u|
      u.permit(:name, :avatar, :email, :password, :password_confirmation, :profile_link, :no_mails)
    }
  end

  def create
    if simple_captcha_valid?
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the captcha code below. Please re-enter the code."
      render :new
    end
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end
end
