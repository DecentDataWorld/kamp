class AddCorporateAuthorshipToResources < ActiveRecord::Migration
  def change
    add_column :resources, :corporate_authorship, :text
  end
end
