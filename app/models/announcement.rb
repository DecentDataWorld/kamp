class Announcement < ActiveRecord::Base
  belongs_to :user
  belongs_to :cop, optional: true

  scope :active, -> () { where("expiration_date >= ?", Time.now).order('expiration_date asc') }
  scope :is_public, -> () { where is_private: false }
  scope :cop, -> (cop) { where cop_id: cop }
  scope :featured, -> () { where is_featured: true }
  

  validates_presence_of :name

  def self.request_email_body(requester)
    if requester
      "<USER NOTE: PLEASE CC THE COR ON THIS EMAIL>\nDear Admin,\n\n User #{requester.email} has requested to post a new announcement to the Jordan KAMP. Please review the announcement details below and create the announcement if you approve.\nName: \nShort Description:\nLong Description:\nExpiration Date:\nFeatured on homepage (y/n)?:\nCOP Announcement (y/n):\nCOP (if applicable):\nPrivate to COP (y/n)?: \n\nBest regards,\nJordan KAMP"
    else
      ""
    end
  end

end
