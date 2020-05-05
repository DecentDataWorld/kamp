class AddResourcesonlyToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :resources_only, :boolean
  end
end
