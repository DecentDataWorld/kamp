class AddApprovedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :approved, :boolean
  end
end
