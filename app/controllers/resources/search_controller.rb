class Resources::SearchController < ResourcesController

  def show
    if params[:q]
      @result = PgSearch.multisearch(params[:q]).page(params[:page]).per(25)
    end
  end
end
