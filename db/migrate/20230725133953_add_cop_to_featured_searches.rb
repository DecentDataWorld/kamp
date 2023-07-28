class AddCopToFeaturedSearches < ActiveRecord::Migration[7.0]
  def change
    add_reference :featured_searches, :cop, null: true, foreign_key: true
  end
end
