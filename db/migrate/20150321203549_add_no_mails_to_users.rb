class AddNoMailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :no_mails, :boolean, default: false
  end
end
