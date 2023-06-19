class Cop < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :resources
  belongs_to :admin, :class_name => 'User'

  validates_presence_of :name
end