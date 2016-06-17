class CreateActivityLogLikes < ActiveRecord::Migration
  def change
    create_table :activity_log_likes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity_log, index: true

      t.timestamps
    end
  end
end
