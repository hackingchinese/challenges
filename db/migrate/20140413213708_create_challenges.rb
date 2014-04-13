class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.date :from_date
      t.date :to_date
      t.string :type

      t.timestamps
    end
    add_index :challenges, :type
  end
end
