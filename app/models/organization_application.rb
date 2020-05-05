class OrganizationApplication < ActiveRecord::Base

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :organization, :class_name => "Organization", :foreign_key => "organization_id"

end
