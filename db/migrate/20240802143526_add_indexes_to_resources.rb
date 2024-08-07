class AddIndexesToResources < ActiveRecord::Migration[7.0]
  def change
    add_index :resources, :approved
    add_index :resources, :private
    add_index :resources, :cop_private
    add_index :resources, :language
    add_index :resources, :updated_at

    add_index :taggings, :tag_id
    add_index :taggings, :taggable_id
    add_index :taggings, :taggable_type
  end
end
