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

end