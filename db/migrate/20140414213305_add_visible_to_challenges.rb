class AddVisibleToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :visible, :boolean
  end
end
