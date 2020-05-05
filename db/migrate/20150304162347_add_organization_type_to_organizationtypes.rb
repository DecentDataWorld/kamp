class AddOrganizationTypeToOrganizationtypes < ActiveRecord::Migration
  def change
    add_column :organization_types, :organization_type, :string
  end
end
