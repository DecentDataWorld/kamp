class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.boolean :visible
      t.string :heading
      t.text :intro_text
      t.string :col1_heading
      t.text :col1_body
      t.string :col2_heading
      t.text :col2_body
      t.string :footnote
      t.string :banner_type

      t.timestamps
    end
  end
end
