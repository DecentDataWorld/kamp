class AddIndexToResources < ActiveRecord::Migration
  def change
    add_index :resources, :ci_lower_bound
  end
end
