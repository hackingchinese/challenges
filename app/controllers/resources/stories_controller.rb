class Resources::StoriesController < ResourcesController
  def index
    @filter = ResourcesFilter.new(params)
  end

  def new
    authorize! :create, Resources::Story
    @story = Resources::Story.new
  end

  def create
    authorize! :create, Resources::Story
    @story = Resources::Story.new(params[:resources_story].permit!)
    @story.user = current_user
    if @story.save
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
        @body = render_to_string partial: @story.reload, format: 'html', short: false
      }
    end

  end
end
