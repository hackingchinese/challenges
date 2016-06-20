class Resources::StoriesController < ResourcesController
  def index
    @stories = Resources::Story.
      includes(:tags, :user).
      order('created_at desc').
      page(params[:page]).per(50)
  end

  def show
    @story = Resources::Story.find(params[:id])
  end

  def toggle_like

  end
end
