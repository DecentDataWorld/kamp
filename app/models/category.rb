class Category < ActiveRecord::Base

  acts_as_taggable

  acts_as_url :name

  validates_presence_of :name, :message => "Name is required"

  def to_param
    url
  end
end
