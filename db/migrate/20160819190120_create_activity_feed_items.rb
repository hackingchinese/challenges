class CreateActivityFeedItems < ActiveRecord::Migration
  def change
    create_view :activity_feed_items
  end
end
