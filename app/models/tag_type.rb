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

    def self.grouped_tags
      grouped_tags = {}
      TagType.all.order(:name).each do |tt|
        tt.tags.order(:name).each do |tag|
          grouped_tags[tt.name] ||= []
          grouped_tags[tt.name] << tag.name
        end
      end
      return grouped_tags
    end
  end
  