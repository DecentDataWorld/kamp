class CreateFeaturedSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :featured_searches do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
