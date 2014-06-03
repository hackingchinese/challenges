class AddUnitQualityTableIdToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :unit_quality_table_id, :integer
    add_index :challenges, :unit_quality_table_id
  end
end
