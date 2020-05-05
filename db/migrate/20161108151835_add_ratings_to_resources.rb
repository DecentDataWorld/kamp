class AddRatingsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :positive, :integer
    add_column :resources, :negative, :integer
    add_column :resources, :ci_lower_bound, :float
  end
end
