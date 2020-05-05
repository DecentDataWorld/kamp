class UserSubscriptions < ActiveRecord::Base

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"

  belongs_to :tag, :class_name => "Tag", :foreign_key => "subscribed_to_id"
  belongs_to :organization, :class_name => "Organization", :foreign_key => "subscribed_to_id"

end
