class Organization < ActiveRecord::Base
  extend Enumerize

  acts_as_url :name

  enumerize :status, in: [:active, :inactive], default: :active

  has_many :collections, :class_name => "Collection", :foreign_key => "organization_id"
  has_many :resources, :class_name => "Resource", :foreign_key => "organization_id"
  has_many :organization_applications, :class_name => "OrganizationApplication", :foreign_key => "organization_id"

  has_many :users, through: :users_organizations
  has_many :users_organizations, :class_name => 'UsersOrganization', dependent: :destroy
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
    if (self.users.exists?(user))
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

  def self.text_search(query)

    if query.present?
      rank = <<-RANK
        ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(query)})) +
        ts_rank(to_tsvector(description), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("name @@ :q or description @@ :q", q: query).order("#{rank} desc")
    else
      scoped
    end

  end

  def to_param
    url
  end

  searchable do
    text :name, :description, :url
    boolean :approved
    string :name
    string :description
    integer :user_ids, :references => User, :multiple => true
    time :created_at
    time :updated_at
  end

end
