class CreateActivityLogComments < ActiveRecord::Migration
  def change
    create_table :activity_log_comments do |t|
      t.belongs_to :user, index: true
      t.text :text
      t.belongs_to :activity_log, index: true

      t.timestamps
    end
  end
end
