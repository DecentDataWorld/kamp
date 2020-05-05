class AddCountercacheToResources < ActiveRecord::Migration
  def change
    add_column :resources, :counter_cache, :integer, :default => 0
  end
end
