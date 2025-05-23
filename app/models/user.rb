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
         :recoverable, :rememberable, :trackable#, :secure_validatable

  scope :do_not_email, -> () { where do_not_email: true }

  attr_accessor :organization_type

  has_many :survey_logs, :class_name => "SurveyLog", :foreign_key => "user_id"
  has_many :resources, :class_name => "Resource", :foreign_key => "author_id"
  has_many :batches, :class_name => "Batch", :foreign_key => "uploader_id"
  has_many :collections_authored, :class_name => "Collection", :foreign_key => "author_id"
  has_many :collections_maintaining, :class_name => "Collection", :foreign_key => "maintainer_id"
  has_many :organization_applications, :class_name => "OrganizationApplication", :foreign_key => "user_id"
  has_many :users_organizations, :class_name => 'UsersOrganization', dependent: :destroy
  has_many :organizations, through: :users_organizations
  has_many :cops, foreign_key: 'admin_id', class_name: 'User', inverse_of: :admin
  
  has_many :subscriptions, :class_name => "UserSubscription", :foreign_key => "user_id"

  has_and_belongs_to_many :cops

  has_attached_file :avatar, :styles => { :small => "190x190>", :thumb => "70x70>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # belongs_to :user_type, :class_name => "UserType", :foreign_key => "user_type_id"

  # after_update :assign_default_role

  def assign_cop
    if (self.organizations & Organization.where(organization_type: 'USAID Implementing Partner')).any?
      self.cops << Cop.where(is_usaid: true).first
    end
  end

  def cop_admin?
    Cop.where(admin_id: self.id).any?
  end

  def assign_default_role
    self.add_role(:member) if self.confirmed? and self.roles.count == 0
  end

  after_create :send_admin_mail

  def send_admin_mail
    @user = self
    unless User.do_not_email.pluck(:email).include? @user.email
      UserMailer.registration_email(@user).deliver
    end
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

  def self.no_role_ids
    query = "select id from users where id not in (select user_id from users_roles)"
    results = ActiveRecord::Base.connection.exec_query(query)
    ids = results.map { |r| r["id"] }
    return ids
  end

  def deactivate
    update_attribute(:deactivated_at, Time.current)
  end

  def reactivate
    update_attribute(:deactivated_at, nil)
  end

  def self.unregistered_do_not_email
    query = "select email from do_not_email"
    results = ActiveRecord::Base.connection.exec_query(query)
    emails = results.map { |r| r["email"]}
    return emails
  end

  def self.unsubscribe(email)
    if User.where(email: email).length > 0
      User.where(email: email).update(do_not_email: true)
    else
      query = "insert into do_not_email (email, created_at, updated_at) values ('#{email}', now(), now());"
      result = ActiveRecord::Base.connection.exec_query(query)
    end
  end

end
