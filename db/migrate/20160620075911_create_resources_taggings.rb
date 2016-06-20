class CreateResourcesTaggings < ActiveRecord::Migration
  def change
    create_table :resources_taggings do |t|
      t.integer :tag_id
      t.integer :story_id

      t.timestamps null: false
    end
    add_index :resources_taggings, [:tag_id, :story_id], unique: true
  end
end
