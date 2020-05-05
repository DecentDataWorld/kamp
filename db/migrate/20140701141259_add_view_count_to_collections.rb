class AddViewCountToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :view_count, :integer
  end
end
