class AddImperssionscountToResources < ActiveRecord::Migration
  def change
    add_column :resources, :impressions_count, :integer
  end
end
