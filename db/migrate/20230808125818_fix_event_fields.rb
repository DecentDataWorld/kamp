class FixEventFields < ActiveRecord::Migration[7.0]
  def change
    change_column(:events, :is_virtual, :boolean, null: false, default: false)
    change_column(:events, :is_featured, :boolean, null: false, default: false)
    remove_column :events, :is_private
    remove_column :events, :date
    add_column :events, :is_private, :boolean, null: false, default: false
    add_column :events, :start_date, :datetime
  end
end
