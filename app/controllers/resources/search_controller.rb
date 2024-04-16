class Resources::SearchController < ResourcesController
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    redirect_to resources_search_path, alert: 'Invalid authenticity token'
  end

  def show
    if params[:q]
      @result = PgSearch.multisearch(params[:q]).page(params[:page]).per(25)
    end
  end
end
