class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :status
      t.integer :author_id
      t.integer :maintainer_id
      t.integer :type_id
      t.integer :organization_id
      t.integer :license_id
      t.text :notes

      t.timestamps
    end
  end
end
