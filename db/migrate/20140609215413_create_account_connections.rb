class CreateAccountConnections < ActiveRecord::Migration
  def change
    create_table :account_connections do |t|
      t.belongs_to :user, index: true
      t.string :provider
      t.string :uid
      t.string :token

      t.timestamps
    end
  end
end
