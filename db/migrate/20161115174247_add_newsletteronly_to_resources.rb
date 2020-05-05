class AddNewsletteronlyToResources < ActiveRecord::Migration
  def change
    add_column :resources, :newsletter_only, :boolean, default: false
  end
end
