class AddCopIdToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :cop_id, :integer
  end
end
