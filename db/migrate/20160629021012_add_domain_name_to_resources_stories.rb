class AddDomainNameToResourcesStories < ActiveRecord::Migration
  def change
    add_column :resources_stories, :domain_name, :string
  end
end
