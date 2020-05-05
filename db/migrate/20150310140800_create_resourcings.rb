class CreateResourcings < ActiveRecord::Migration
  def change
    create_table :resourcings do |t|
      t.integer :resource_id
      t.integer :resourceable_id
      t.string :resourceable_type

      t.timestamps
    end
  end
end
