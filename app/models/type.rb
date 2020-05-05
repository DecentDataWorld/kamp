class Type < ActiveRecord::Base
  has_many :collections, :class_name => "Collection", :foreign_key => "type_id"
end
