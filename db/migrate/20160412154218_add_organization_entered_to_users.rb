class AddOrganizationEnteredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organization_entered, :text
  end
end
