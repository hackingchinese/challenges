class AddScoreToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :score, :decimal, :precision => 8, :scale => 3
    add_index :participations, :score
  end
end
