class Resources::StoriesController < ResourcesController
  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to '/resources/stories', alert: "Your request has expired, please try again"
  end
  def index
    @filter = ResourcesFilter.new(params)
    respond_to do |f|
      f.html
      f.rss
    end
  end

  def new
    authorize! :create, Resources::Story
    @story = Resources::Story.new
  end

  def create
    authorize! :create, Resources::Story
    @story = Resources::Story.new(permitted_params)
    @story.user = current_user
    if @story.save
      Rails.cache.delete_matched('tag_counts.*')
      @story.liked_by << current_user
      MailPreference.notifiable_users(:new_resource).each do |user|
        next if user == @story.user
        Resources::Mailer.new_resource(@story, user).deliver_now
      end
      redirect_to resources_story_path(@story), notice: "Resource created!"
    else
      render :new
    end
  end

  def show
    @story = Resources::Story.find(params[:id])
    @page_title = @story.title
    @page_description = @story.description
  end

  def edit
    @story = Resources::Story.find(params[:id])
    authorize! :edit, @story
  end

  def update
    @story = Resources::Story.find(params[:id])
    authorize! :edit, @story
    if @story.update(permitted_params)
      Rails.cache.delete_matched('tag_counts.*')
      redirect_to resources_story_path(@story), notice: "Resource updated!"
    else
      render :edit
    end
  end

  def toggle_like
    @story = Resources::Story.find(params[:id])
    if !can?(:like, @story)
      respond_to do |f|
        f.html {
          authorize! :like, @story
        }
        f.js { render 'unauthorized' }

      end
      return
    end
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
        @body = render_to_string partial: @story.reload, format: 'html', short: false
      }
    end
  end

  def destroy
    @story = Resources::Story.find(params[:id])
    authorize! :destroy, @story
    @story.destroy
    redirect_to resources_path
  end

  private

  def permitted_params
    p = params.require(:resources_story).permit(:title, :url, :description, :image, :image_cache, :tag_ids => [])
    if p[:image].present?
      p.delete :image_cache
    end
    p
  end
end
