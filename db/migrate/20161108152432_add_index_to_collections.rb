class AddIndexToCollections < ActiveRecord::Migration
  def change
    add_index :collections, :ci_lower_bound
  end
end
