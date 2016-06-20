class AddImportedFromResourcesIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :imported_from_resources_id, :integer, comment: "user-id by former resources.hc website"
  end
end
