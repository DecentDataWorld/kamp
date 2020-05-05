class AddIssueDateToResources < ActiveRecord::Migration
  def change
    add_column :resources, :issue_date, :date
  end
end
