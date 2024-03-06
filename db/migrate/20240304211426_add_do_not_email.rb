class AddDoNotEmail < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :do_not_email, :boolean, null: false, default: false

    create_table :do_not_email do |t|
      t.string :email, null: false
      t.timestamps
    end
  end
end
