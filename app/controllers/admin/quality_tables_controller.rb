class Admin::QualityTablesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def permitted_params
    params.permit!
  end
end
