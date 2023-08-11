class Announcement < ActiveRecord::Base
  belongs_to :user
  belongs_to :cop, optional: true

  scope :active, -> () { where("expiration_date >= ?", Time.now).order('expiration_date asc') }
  scope :is_public, -> () { where is_private: false }
  scope :cop, -> (cop) { where cop_id: cop }
  scope :featured, -> () { where is_featured: true }
  

  validates_presence_of :name
end
