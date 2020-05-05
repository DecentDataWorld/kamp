class ChangeIssueDateToStringInResources < ActiveRecord::Migration
  def up
    remove_column :resources, :issue_date
    add_column :resources, :issue_date, :integer
  end

  def down
    change_column :resources, :issue_date, :date
  end
end
