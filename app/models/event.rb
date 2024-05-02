require 'uri'
class Event < ActiveRecord::Base

  belongs_to :user
  belongs_to :cop, optional: true

  scope :active, -> () { where("start_date >= ?", Time.now).order('start_date asc') }
  scope :is_public, -> () { where is_private: false }
  scope :cop, -> (cop) { where cop_id: cop }
  scope :featured, -> () { where is_featured: true }

  validates_presence_of :name, :message => "Name is required"
  validates_presence_of :start_date, :message => "Date is required"

  def valid_url?(uri)
    uri = URI.parse(uri)
    uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def https_url
    pattern1 = "https://"
    pattern2 = "http://"
    unless self.url.match(/^(#{pattern1}|#{pattern2})/)
      return "http://#{self.url}"
    end
    self.url
  end

  def self.request_email_body(requester)
    if requester
      "<USER NOTE: PLEASE CC THE COR ON THIS EMAIL>\nDear Admin,\n\n User #{requester.email} has requested to post a new event to the Jordan KAMP. Please review the event details below and create the event if you approve.\nName: \nShort Description:\nFull Description:\nDate:\nLocation\nFeatured on homepage (y/n)?:\nVirtual/Online (y/n)?:\nURL:\nCOP Event (y/n):\nCOP (if applicable):\nPrivate to COP (y/n)?: \n\nBest regards,\nJordan KAMP"
    else
      ""
    end
  end

end