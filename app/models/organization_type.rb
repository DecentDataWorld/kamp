class OrganizationType < ActiveRecord::Base
  has_many :organizations, :class_name => "Organization", :foreign_key => "organization_type_id"
  validates_presence_of :organization_type, :message => "Organization Type is required"
end
