class AddCopToResources < ActiveRecord::Migration[7.0]
  def change
    add_reference :resources, :cop, null: true, foreign_key: true
    add_column :resources, :cop_private, :boolean, :null => false, :default => false
  end
end
