class AddRatingsToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :positive, :integer
    add_column :collections, :negative, :integer
    add_column :collections, :ci_lower_bound, :float
  end
end
