class AddPrivateToResources < ActiveRecord::Migration
  def change
    add_column :resources, :private, :integer
  end
end
