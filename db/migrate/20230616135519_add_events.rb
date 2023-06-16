class AddEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :short_description
      t.text :long_description
      t.datetime :date
      t.string :location
      t.boolean :virtual
      t.string :url
      t.string :public
      t.boolean :featured
      t.references :creator, index: true, foreign_key: {to_table: :users}
      t.references :cop, index: true, foreign_key: true
      t.timestamps
    end

    create_join_table :events, :tags do |t|
      t.index [:event_id, :tag_id]
      t.index [:tag_id, :event_id]
      t.timestamps
    end

  end
end
