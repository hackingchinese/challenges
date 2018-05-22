class AddGdprConsentGivenOnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gdpr_consent_given_on, :datetime
  end
end
