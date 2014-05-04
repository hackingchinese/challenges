class AddGoalTypeToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :goal_type, :integer
    add_index :challenges, :goal_type
  end
end
