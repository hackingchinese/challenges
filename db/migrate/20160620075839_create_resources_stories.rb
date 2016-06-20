class CreateResourcesStories < ActiveRecord::Migration
  def change
    create_table :resources_stories do |t|
      t.string :url
      t.string :title
      t.string :short_id
      t.belongs_to :user, index: true, foreign_key: true
      t.text :description
      t.string :image
      t.integer :comments_count
      t.integer :like_count

      t.timestamps null: false
    end
    add_index :resources_stories, :url, unique: true
    add_index :resources_stories, :short_id, unique: true
  end
end
