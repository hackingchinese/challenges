class AddDescriptionToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :description, :text
  end
end
