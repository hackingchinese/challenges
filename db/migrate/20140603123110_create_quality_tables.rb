class CreateQualityTables < ActiveRecord::Migration
  def change
    create_table :quality_tables do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
