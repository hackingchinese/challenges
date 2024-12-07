class AddIndexOnResourcesTagsTier < ActiveRecord::Migration[5.2]
  def change
    add_index :resources_tags, :tier
  end
end
