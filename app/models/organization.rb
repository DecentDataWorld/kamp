class Organization < ActiveRecord::Base
  extend Enumerize

  acts_as_url :name

  enumerize :status, in: [:active, :inactive], default: :active

  has_many :collections, :class_name => "Collection", :foreign_key => "organization_id"
  has_many :resources, :class_name => "Resource", :foreign_key => "organization_id"
  has_many :organization_applications, :class_name => "OrganizationApplication", :foreign_key => "organization_id"

  has_many :users_organizations, :class_name => 'UsersOrganization', dependent: :destroy
  has_many :users, through: :users_organizations
  belongs_to :organization_type, :class_name => "OrganizationType", :foreign_key => "organization_type_id"

  validates_presence_of :name, :message => "Name is required"

  has_attached_file :logo, :styles => { :xlarge => "470x315>", :large => "300x200>", :medium => "240x160>", :small => "200x130>", :thumb => "100x70>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :users_organizations, :allow_destroy => true

  attr_accessor :creator_id

  def can_manage_users(user)
    return false if user.nil?

    user_org = UsersOrganization.find_by :user_id => user.id, :organization_id => self.id

    if !user_org.nil? and (user_org.role == "editor" || user_org.role == "admin")
      return true
    else
      return false
    end

  end

  def can_edit_organization(user)
    return false if user.nil?

    user_org = UsersOrganization.find_by :user_id => user.id, :organization_id => self.id

    if !user_org.nil? and user_org.role == "admin"
      return true
    else
      return false
    end

  end

  def can_add_collections(user)
    if user && self.users.exists?(user.id)
      return true
    else
      return false
    end
  end

  def admins
    return UsersOrganization.where("organization_id = ?", self.id).where("role = ?", "admin")
  end

  def editors
    return UsersOrganization.where("organization_id = ?", self.id).where("role = ?", "editor")
  end

  def members
    return UsersOrganization.where("organization_id = ?", self.id).where("role = ?", "member")
  end

  def private_resources
    return Resource.where("organization_id = ?", self.id).where("private = ?", true)
  end

  def to_param
    url
  end

  def deactivate
    update_attribute(:deactivated_at, Time.current)
  end

  def reactivate
    update_attribute(:deactivated_at, nil)
  end

end
