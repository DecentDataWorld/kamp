class Event < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  belongs_to :cop, optional: true
  has_and_belongs_to_many :tags

  validates_presence_of :name, :message => "Name is required"
end