class Admin::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    grid_params = params.fetch(:users_grid, {}).permit!
    @grid = UsersGrid.new(grid_params) do |scope|
      scope.page(params[:page])
    end
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

  def block
    @user.update_attribute(:blocked, true)
    redirect_back fallback_location: '/admin/users', notice: 'User has been blocked/hidden from leaderboards'
  end

  def unblock
    @user.update_attribute(:blocked, false)
    redirect_back fallback_location: '/admin/users', notice: 'User has been unblocked/shows now in leaderboards'
  end
end
