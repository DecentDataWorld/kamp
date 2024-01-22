class AddUsaidBoolToCop < ActiveRecord::Migration[7.0]
  def change
    add_column :cops, :is_usaid, :boolean, null: false, default: false
  end
end
