class AddMinutesToActivityLogs < ActiveRecord::Migration
  def change
    add_column :activity_logs, :minutes, :integer
  end
end
