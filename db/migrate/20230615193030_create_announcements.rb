class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.string :name, null: false
      t.string :short_description
      t.text :long_description
      t.datetime :expiration_date
      t.boolean :is_private, null: false, default: false
      t.boolean :is_featured, null: false, default: false
      t.references :user, null: false, foreign_key: true, index: true
      t.references :cop, null: true, foreign_key: true, index: true
      t.timestamps
    end
  end
end
