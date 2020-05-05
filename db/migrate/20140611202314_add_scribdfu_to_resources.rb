class AddScribdfuToResources < ActiveRecord::Migration
  def change
    add_column :resources, :ipaper_id, :integer
    add_column :resources, :ipaper_access_key, :string
  end
end
