class AddAttachmentImageToCollections < ActiveRecord::Migration
  def self.up
    change_table :collections do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :collections, :image
  end
end
