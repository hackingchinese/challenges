class CreateUnitTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_types do |t|
      t.string :key
      t.string :action
      t.string :singular
      t.string :plural
      t.string :verb_present
      t.string :verb_past
      t.json :texts

      t.timestamps
    end
    add_index :unit_types, :key, unique: true

    add_column :challenges, :unit_type_id, :integer
    add_index :challenges, :unit_type_id
  end
end
