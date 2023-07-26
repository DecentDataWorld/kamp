class AddDeactivatedTimeToOrgs < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :deactivated_at, :datetime
  end
end
