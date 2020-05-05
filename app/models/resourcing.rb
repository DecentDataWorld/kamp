class Resourcing < ActiveRecord::Base
  belongs_to :resource
  belongs_to :resourceable, polymorphic: true
  accepts_nested_attributes_for :resource
end
