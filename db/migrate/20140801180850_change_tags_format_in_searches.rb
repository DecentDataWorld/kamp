class ChangeTagsFormatInSearches < ActiveRecord::Migration
  def up
    change_column :searches, :tags, :text
  end

  def down
    change_column :searches, :tags, :string
  end
end
