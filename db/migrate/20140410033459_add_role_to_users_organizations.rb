class AddRoleToUsersOrganizations < ActiveRecord::Migration
  def change
    add_column :users_organizations, :role, :string
  end
end
