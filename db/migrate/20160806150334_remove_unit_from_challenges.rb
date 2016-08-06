class RemoveUnitFromChallenges < ActiveRecord::Migration[5.0]
  def change
    remove_column :challenges, :unit
  end
end
