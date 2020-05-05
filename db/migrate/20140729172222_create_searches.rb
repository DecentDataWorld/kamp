class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query
      t.string :tags
      t.integer :organization_id
      t.integer :license_id
      t.string :resource_type
      t.string :language

      t.timestamps
    end
  end
end
