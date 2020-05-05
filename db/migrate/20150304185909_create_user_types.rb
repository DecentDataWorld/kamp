class CreateUserTypes < ActiveRecord::Migration
  def change
    create_table :user_types do |t|
      t.string :user_type

      t.timestamps
    end
  end
end
