class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :challenge, index: true
      t.integer :goal_hours
      t.integer :goal_units

      t.timestamps
    end
  end
end
