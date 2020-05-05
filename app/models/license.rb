class License < ActiveRecord::Base

  validates_presence_of :name, :message => "License Text is required"

  has_many :collections, :class_name => "Collection", :foreign_key => "license_id"
  has_many :resources, :class_name => "Resource", :foreign_key => "license_id"
end
