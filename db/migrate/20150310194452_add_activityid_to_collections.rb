class AddActivityidToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :activity_id, :integer
  end
end
