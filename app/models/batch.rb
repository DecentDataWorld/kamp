class Batch < ActiveRecord::Base
  has_many :resources, :class_name => "Resource", :foreign_key => "batch_id"
  belongs_to :uploader, :class_name => "User", :foreign_key => "uploader_id"
end
