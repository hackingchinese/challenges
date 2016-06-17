class AddUniqIndexToLikes < ActiveRecord::Migration
  def change
    add_index :activity_log_likes, [:user_id, :activity_log_id], unique: true
  end
end
