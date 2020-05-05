class ChangeFootnoteToTextInBanners < ActiveRecord::Migration
  def change
    change_column :banners, :footnote, :text
  end
end
