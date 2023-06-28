class Announcement < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  belongs_to :cop, optional: true

  validates_presence_of :name
end
