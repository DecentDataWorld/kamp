class AddUniqueIndexToUsersOrganizations < ActiveRecord::Migration[7.0]
  def change
    # add_index :users_organizations, [:user_id, :organization_id], unique: true
  end
end
