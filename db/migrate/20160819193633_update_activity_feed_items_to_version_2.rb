class UpdateActivityFeedItemsToVersion2 < ActiveRecord::Migration
  def change
    update_view :activity_feed_items, version: 2, revert_to_version: 1
  end
end
