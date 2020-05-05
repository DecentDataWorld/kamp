class UserType < ActiveRecord::Base
  has_many :users, :class_name => "User", :foreign_key => "user_type_id"
  validates_presence_of :user_type, :message => "User Type is required"
end
