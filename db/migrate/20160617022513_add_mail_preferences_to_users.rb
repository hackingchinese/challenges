class AddMailPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_preferences, :json
  end
end
