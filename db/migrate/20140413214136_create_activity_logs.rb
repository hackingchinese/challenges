class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.belongs_to :user, index: true
      t.belongs_to :participation, index: true
      t.decimal :hours_spent
      t.string :hour_measure
      t.integer :units_accomplished
      t.string :units_measure
      t.text :comment
      t.float :score

      t.timestamps
    end
  end
end
