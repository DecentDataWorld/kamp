class CreateUserSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_subscriptions do |t|
      t.integer :user_id
      t.string :subscribed_to
      t.integer :subscribed_to_id

      t.timestamps
    end
  end
end
