class AddImperssionscountToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :impressions_count, :integer
  end
end
