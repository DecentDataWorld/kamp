class TagType < ActiveRecord::Base
    has_many :tags
  
    validates_presence_of :name
  
    def self.to_option_values
      objects = self.order(:name)
      values = Hash.new
      
      objects.each do |o|
        values[o.name] = o.id
      end
      return values
    end
  end
  