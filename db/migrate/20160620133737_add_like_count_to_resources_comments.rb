class AddLikeCountToResourcesComments < ActiveRecord::Migration
  def change
    add_column :resources_comments, :like_count, :integer, default: 0
  end
end
