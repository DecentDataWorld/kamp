class Cop < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :resources
  belongs_to :admin, :class_name => 'User'
  has_many :featured_searches

  validates_presence_of :name
end