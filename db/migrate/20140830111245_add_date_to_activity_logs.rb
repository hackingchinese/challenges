class AddDateToActivityLogs < ActiveRecord::Migration
  def change
    add_column :activity_logs, :date, :date
    execute 'update activity_logs set date=created_at'
  end
end
