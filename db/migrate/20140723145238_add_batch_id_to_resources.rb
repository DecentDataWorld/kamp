class AddBatchIdToResources < ActiveRecord::Migration
  def change
    add_column :resources, :batch_id, :integer
  end
end
