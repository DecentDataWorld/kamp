class CreateUsersOrganizations < ActiveRecord::Migration
  def change
    create_table :users_organizations do |t|
      t.integer :user_id
      t.integer :organization_id

      t.timestamps
    end
  end
end
