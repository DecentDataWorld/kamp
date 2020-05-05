class AddPrivateToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :private, :boolean, :default => nil
  end
end
