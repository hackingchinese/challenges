class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.order('last_sign_in_at is null, last_sign_in_at desc').includes(:account_connections)
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
