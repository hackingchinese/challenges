class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.order('last_sign_in_at is null, last_sign_in_at desc').includes(:account_connections, :mail_preference)
  end

  def update
    if params[:disable_email] == '1'
      @user.mail_preference.disable!
    else
      raise NotImplementedError
    end
    respond_to do |f|
      f.html {
        redirect_to '/admin/users'
      }
      f.js
    end
  end

  def destroy
    @user.destroy
    respond_to do |f|
      f.html {
        redirect_to '/admin/users'
      }
      f.js
    end
  end
end
