class AddCollectionsonlyToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :collections_only, :boolean
  end
end
