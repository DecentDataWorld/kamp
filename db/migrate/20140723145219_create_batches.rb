class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.string :name
      t.integer :uploader_id

      t.timestamps
    end
  end
end
