class AddApprovedToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :approved, :boolean, :default => false
  end
end
