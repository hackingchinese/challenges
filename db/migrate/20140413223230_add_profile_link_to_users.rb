class AddProfileLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_link, :string
  end
end
