class AddUniqueConstraintToCopsUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :cops_users, [:cop_id, :user_id], unique: true, name: "cops_users_unique_index"
  end
end
