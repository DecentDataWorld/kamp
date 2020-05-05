class AddNewsletteronlyToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :newsletter_only, :boolean, default: false
  end
end
