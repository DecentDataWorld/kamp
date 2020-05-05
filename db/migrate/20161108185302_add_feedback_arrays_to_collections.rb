class AddFeedbackArraysToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :positive_users, :string, array: true, default: []
    add_column :collections, :negative_users, :string, array: true, default: []
  end
end
