class AddViewCountToResources < ActiveRecord::Migration
  def change
    add_column :resources, :view_count, :integer
  end
end
