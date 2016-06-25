class CreateMailPreferences < ActiveRecord::Migration
  def change
    create_table :mail_preferences do |t|
      t.belongs_to :user, index: true
      t.json :mails_enabled

      t.timestamps
    end
    remove_column :users, :mail_preferences
  end
end
