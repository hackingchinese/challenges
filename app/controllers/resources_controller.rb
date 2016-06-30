class ResourcesController < ApplicationController
  protected
  before_action do
    @site_title = (Rails.env.development? ? "(DEV) " : "") + ' HC Resources'
    @page_description = 'Hacking Chinese Resources - Curated links and resources for learning Chinese'
  end
  def navigation_name
    'resources'
  end
end
