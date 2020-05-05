class Activity < ActiveRecord::Base

  acts_as_url :name

  has_many :resources, :class_name => "Resource", :foreign_key => "activity_id"
  has_many :collections, :class_name => "Collection", :foreign_key => "activity_id"

  validates_presence_of :name, :message => "Name is required"

  def to_param
    url
  end
end
