class AddTimeQualityTableIdToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :time_quality_table_id, :integer
    add_index :challenges, :time_quality_table_id
  end
end
