class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :url
      t.string :name
      t.text :description
      t.string :format
      t.integer :collection_id
      t.string :status
      t.string :resource_type

      t.timestamps
    end
  end
end
