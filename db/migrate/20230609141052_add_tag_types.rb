class AddTagTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_types do |t|
      t.string :name
      t.timestamps
    end

    add_reference :tags, :tag_type, foreign_key: true
  end
end
