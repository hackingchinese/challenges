class CreateResourcesComments < ActiveRecord::Migration
  def change
    create_table :resources_comments do |t|
      t.belongs_to :story, index: true
      t.belongs_to :user, index: true
      t.text :comment

      t.timestamps null: false
    end
  end
end
