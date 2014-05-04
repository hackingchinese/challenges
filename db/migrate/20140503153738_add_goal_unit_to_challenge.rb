class AddGoalUnitToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :unit, :string
  end
end
