class AddExpiredAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expired_at, :datetime
  end
end
