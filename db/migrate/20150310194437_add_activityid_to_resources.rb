class AddActivityidToResources < ActiveRecord::Migration
  def change
    add_column :resources, :activity_id, :integer
  end
end
