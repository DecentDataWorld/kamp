class AddTagAndOrgIndexes < ActiveRecord::Migration
  def change
    add_index :taggings, [:taggable_id, :taggable_type, :tag_id], name: "taggable_resources_index"
    add_index :resources, :organization_id
    add_index :collections, :organization_id
  end
end
