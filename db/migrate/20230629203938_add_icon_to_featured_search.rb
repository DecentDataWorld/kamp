class AddIconToFeaturedSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :featured_searches, :icon_identifier, :string
  end
end
