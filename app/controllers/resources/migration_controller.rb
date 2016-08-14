class Resources::MigrationController < ApplicationController
  def story_redirect
    story = Resources::Story.find_by!(short_id: params[:short_id])
    redirect_to resources_story_path(story), status: :moved_permanently
  end

  def tag_redirect
  # MISSING /t/News/Resource-collections/Tools-and-Apps/Simplified-Characters
    tag_names = [params[:tag1], params[:tag2], params[:tag3], params[:tag4] ].reject(&:blank?)
    tags = Resources::Tag.where(name: tag_names).map{|i| [i.tier, i.name] }.group_by(&:first).transform_values{|v| v.map(&:last).join("+") }

    url = url_for( tags.merge(controller: 'resources/stories', action: 'index', only_path: true))
    redirect_to url, status: :moved_permanently
  end

  def user_page
    user = User.find_by!(name: params[:username])
    redirect_to user_path(user), status: :moved_permanently
  end
end
