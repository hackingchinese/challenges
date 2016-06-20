class CreateResourcesLikes < ActiveRecord::Migration
  def change
    create_table :resources_likes do |t|
      t.belongs_to :story, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
