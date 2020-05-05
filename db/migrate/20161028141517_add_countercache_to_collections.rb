class AddCountercacheToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :counter_cache, :integer, :default => 0
  end
end
