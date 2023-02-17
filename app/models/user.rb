class User < ActiveRecord::Base

  # allowing use of can? in models
  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :secure_validatable

  has_many :survey_logs, :class_name => "SurveyLog", :foreign_key => "user_id"
  has_many :resources, :class_name => "Resource", :foreign_key => "author_id"
  has_many :batches, :class_name => "Batch", :foreign_key => "uploader_id"
  has_many :collections_authored, :class_name => "Collection", :foreign_key => "author_id"
  has_many :collections_maintaining, :class_name => "Collection", :foreign_key => "maintainer_id"
  has_many :organization_applications, :class_name => "OrganizationApplication", :foreign_key => "user_id"

  has_many :organizations, through: :users_organizations
  has_many :users_organizations, :class_name => 'UsersOrganization', dependent: :destroy

  has_many :subscriptions, :class_name => "UserSubscription", :foreign_key => "user_id"

  has_attached_file :avatar, :styles => { :small => "190x190>", :thumb => "70x70>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  belongs_to :user_type, :class_name => "UserType", :foreign_key => "user_type_id"
=begin
  searchable do
    text :name
    text :about
    text :title
    integer :organization_ids, :references => Organization, :multiple => true
  end
=end 

  # after_update :assign_default_role

  def assign_default_role
    self.add_role(:member) if self.confirmed? and self.roles.count == 0
  end

  #after_create :send_admin_mail

  def send_admin_mail
    @user = self
    UserMailer.registration_email(@user).deliver
  end

  def has_approved_org
    is_addable = false
    self.organizations.each do |org|
      if org.approved
        is_addable = true
      end
    end
    return is_addable
  end

  def has_org(org)
    return self.users_organizations.where("organization_id = ?", org.id)
  end

end
