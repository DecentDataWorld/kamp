class Collection < ActiveRecord::Base
  extend Enumerize

  attr_accessor :reason

  acts_as_url :title

  enumerize :status, in: [:active, :inactive], default: :active

  is_impressionable :counter_cache => true, :unique => true

  validates_presence_of :title, :message => "Title is required"
  validates_presence_of :description, :message => "A description is required"

  #has_many :resources, :class_name => "Resource", :foreign_key => "collection_id"
  has_many :resourcings, :as => :resourceable
  has_many :resources, :through => :resourcings

  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :activity, :class_name => "Activity", :foreign_key => "activity_id"
  belongs_to :maintainer, :class_name => "User", :foreign_key => "maintainer_id"
  belongs_to :organization, :class_name => "Organization", :foreign_key => "organization_id"
  belongs_to :type, :class_name => "Type", :foreign_key => "type_id"
  belongs_to :license, :class_name => "License", :foreign_key => "license_id"

  scope :by_author, lambda{ |author_id| where(author_id: author_id) unless author_id.nil? }
  scope :by_maintainer, lambda{ |maintainer_id| where(maintainer_id: maintainer_id) unless maintainer_id.nil? }
  scope :by_organization, lambda{ |organization_id| where(organization_id: organization_id) unless organization_id.nil? }
  scope :by_type, lambda{ |type_id| where(type_id: type_id) unless type_id.nil? }
  scope :by_license, lambda{ |license_id| where(license_id: license_id) unless license_id.nil? }

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :tags

  has_attached_file :image, :styles => { :xlarge => "470x315>", :large => "300x200>", :medium => "240x160>", :small => "200x130>", :thumb => "100x70>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def self.text_search(query)

    if query.present?
      rank = <<-RANK
        ts_rank(to_tsvector(title), plainto_tsquery(#{sanitize(query)})) +
        ts_rank(to_tsvector(description), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("title @@ :q or description @@ :q", q: query).order("#{rank} desc")
    else
      scoped
    end

  end

  def to_param
    url
  end

  def can_edit(user)
    return false if user.nil?
    user_org = UsersOrganization.find_by :user_id => user.id, :organization_id => self.organization.id
    if (self.author == user) or (!user_org.nil? and (user_org.role == :editor or user_org.role == :admin or user_org.role == "editor" or user_org.role == "admin"))
      return true
    else
      return false
    end
  end

  def can_add_resources(user)
    return false if user.nil?
    user_org = UsersOrganization.where("user_id = ?", user.id).where("organization_id = ?", self.organization.id)
    if (!user_org.nil? and (user_org.role == :editor or user_org.role == :admin or user_org.role == "editor" or user_org.role == "admin")) or (self.author == user)
      puts 'returning true to add check'
      return true
    else
      puts 'returning false to add check' + user_org.role.inspect
      return false
    end
  end

  def has_in_org(user)
    return false if user.nil?
    return false if self.organization.nil?
    user_org = UsersOrganization.where("user_id = ?", user.id).where("organization_id = ?", self.organization.id)
    if(!user_org.nil?)
      return true
    else
      return false
    end

  end

  def self.search_kmp(search_terms=nil, tags=nil)
    query = "
      WITH collections_search AS (
        SELECT 
          c.id,
          c.updated_at,
          setweight(to_tsvector('english', c.title), 'A') || 
          setweight(to_tsvector('english', c.description), 'B') as document
        FROM collections c
      ),
      filtered_collections_tags AS (
        SELECT c.id 
        FROM collections c
        INNER JOIN taggings tg on c.id = tg.taggable_id and tg.taggable_type = 'Collection'
        INNER JOIN tags t on tg.tag_id = t.id"
        query = query + "
        WHERE 0=0 "
        query = query + " AND tg.tag_id IN (" + tags.join(",") + ")" if !tags.nil? && tags.length > 0
        query = query + " GROUP BY c.id "
        query = query + " HAVING COUNT( c.id )=" + tags.length.to_s if !tags.nil? && tags.length > 0
        query = query + "
      )
      SELECT 
        cs.id,
        cs.updated_at
      FROM collections_search cs
      INNER JOIN filtered_collections_tags fct on cs.id = fct.id
      WHERE 0=0 "
      if !search_terms.nil? && search_terms.length > 0
        query = query + " AND cs.document @@ to_tsquery('english', '" + search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') + "')"
      end
  
      results = Collection.find_by_sql(query)
      ids = results.map { |c| c.id }
      count = ids.length
  
      return {ids: ids, count: count}
  end

end
