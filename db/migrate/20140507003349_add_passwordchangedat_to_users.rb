class AddPasswordchangedatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_changed_at, :datetime
  end
end
