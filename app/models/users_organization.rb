class UsersOrganization < ActiveRecord::Base
  extend Enumerize
  belongs_to :user
  belongs_to :organization

  validates_presence_of :organization, :message => "Organization is required"
  validates_presence_of :user, :message => "Picking a member is required"
  validates :user, uniqueness: { scope: :organization, message: "User already belongs to this organization." }

  enumerize :role, in: [:member, :editor, :admin], default: :member
end

