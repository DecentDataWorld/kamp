class Cop < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :resources, dependent: :nullify
  belongs_to :admin, :class_name => 'User'
  has_many :featured_searches, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :announcements, dependent: :destroy
  scope :admin, -> (user_id) { where admin_id: user_id }

  validates_presence_of :name

  def self.is_user_cop_admin(user)
    return Cop.joins(:users).where("users.id = ? and cops.admin_id = ?", user.id, user.id).first
  end

  def private_resources
    return Resource.where("cop_id = ?", self.id).where("cop_private = ?", true)
  end

end