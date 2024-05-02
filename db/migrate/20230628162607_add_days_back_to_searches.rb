class AddDaysBackToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :days_back, :integer
  end
end
