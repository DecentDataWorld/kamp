class CreateOrganizationTypes < ActiveRecord::Migration
  def change
    create_table :organization_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
