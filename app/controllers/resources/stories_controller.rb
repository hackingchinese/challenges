class Resources::StoriesController < ResourcesController
  def index
    @filter = ResourcesFilter.new(params)
  end

  def show
    @story = Resources::Story.find(params[:id])
  end

  def toggle_like
    @story = Resources::Story.find(params[:id])
    authorize! :like, @story
    existing = @story.likes.where(user_id: current_user.id).first_or_initialize
    if existing.new_record?
      existing.save
    else
      existing.destroy
    end
    respond_to do |f|
      f.html {
        redirect_to resources_story_path(@story)
      }
      f.js {
        @body = render_to_string partial: @story.reload, format: 'html'
      }
    end

  end
end
