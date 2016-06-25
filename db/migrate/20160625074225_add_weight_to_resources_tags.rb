class AddWeightToResourcesTags < ActiveRecord::Migration
  def change
    add_column :resources_tags, :weight, :integer, default: 0
  end
end
