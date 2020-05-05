class AddApprovedToResources < ActiveRecord::Migration
  def change
    add_column :resources, :approved, :boolean, :default => false
  end
end
