class CreateOrganizationApplications < ActiveRecord::Migration
  def change
    create_table :organization_applications do |t|
      t.integer :user_id
      t.integer :organization_id
      t.boolean :approved

      t.timestamps
    end
  end
end
