class ChangeSourceUrLinResources < ActiveRecord::Migration
  def up
    change_column :resources, :source, :text
  end

  def down
    change_column :resources, :source, :string
  end
end
