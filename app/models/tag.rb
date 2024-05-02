class Tag < ActiveRecord::Base
    belongs_to :tag_type
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
      tags = "
        SELECT
          t.id,
          t.name,
          tt.id as tag_type_id,
          tt.name as tag_type_name
        FROM tags t
        INNER JOIN tag_types tt ON t.tag_type_id = tt.id
        ORDER BY tt.name, t.name"
      data = Tag.find_by_sql(tags)
  
      tag_types = {}
  
      data.each do |t|
        tag_types[t.tag_type_name] = {:tags => [], :id => t.tag_type_id} if tag_types[t.tag_type_name] == nil
        tag_types[t.tag_type_name][:tags].append({"name":t.name, "id":t.id})
      end
  
      return tag_types
    end
  
    def self.tags_list
      columns = [
        {
          "Header": I18n.t('activerecord.attributes.tag.name'),
          "accessor": "name"
        },
        {
          "Header": I18n.t('activerecord.attributes.tag.tag_type'),
          "accessor": "tag_type_name"
        }
      ]
  
  
      tags = Tag.find_by_sql(
        'SELECT 
          t.id,
          t.name,
          tt.name AS tag_type_name
        FROM tags t
        INNER JOIN tag_types tt on tt.id = t.tag_type_id
        ORDER BY t.name'
      )
  
      return {data: tags, columns: columns}
    end

  end
  