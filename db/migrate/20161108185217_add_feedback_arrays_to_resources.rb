class AddFeedbackArraysToResources < ActiveRecord::Migration
  def change
    add_column :resources, :positive_users, :string, array: true, default: []
    add_column :resources, :negative_users, :string, array: true, default: []
  end
end
