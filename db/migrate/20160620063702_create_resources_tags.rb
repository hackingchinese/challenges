class CreateResourcesTags < ActiveRecord::Migration
  def change
    create_table :resources_tags do |t|
      t.string :name
      t.boolean :important
      t.integer :tier

      t.timestamps null: false
    end
  end
end
