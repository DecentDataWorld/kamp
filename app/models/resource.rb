class Resource < ActiveRecord::Base
  extend Enumerize

  attr_accessor :reason

  acts_as_taggable

  acts_as_url :name

  enumerize :status, in: [:active, :inactive], default: :active

  enumerize :resource_type, in: ["Other", "CSV", "PDF", "Document", "Spreadsheet", "GeoJSON", "Presentation", "Image", "Text"], default: "Other"

  enumerize :language, in: [:english, :arabic], default: :english

  is_impressionable :counter_cache => true, :unique => true

  validates_presence_of :name, :message => "Name is required"
  validates_presence_of :description, :message => "A description of this resource is required"
  validates_presence_of :resource_type, :message => "Choose a resource type"
  validates_presence_of :tag_list, :message => "Choose at least one tag"
  validate :attachment_or_source

  has_many :resourcings
  has_many :collections, :through => :resourcings, :source => :resourceable, :source_type => 'Collection'
  belongs_to :activity, :class_name => "Activity", :foreign_key => "activity_id", :optional => true
  belongs_to :collection, :class_name => "Collection", :foreign_key => "collection_id", :optional => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :organization, :class_name => "Organization", :foreign_key => "organization_id"
  belongs_to :license, :class_name => "License", :foreign_key => "license_id", :optional => true
  belongs_to :batch, :class_name => "Batch", :foreign_key => "batch_id",  :optional => true
  belongs_to :cop, :class_name => "Cop", :foreign_key => "cop_id",  :optional => true

  has_attached_file :attachment
  # do_not_validate_attachment_file_type :attachment
  validates_attachment_content_type :attachment, content_type: /\Aapplication/

  has_and_belongs_to_many :cops

  # before_create :scan_for_viruses

  def popularity_query
    Resource.find_by_sql ['SELECT id, title, positive, negative,
        ((positive + 1.9208) / (positive + negative) -
        1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
        (positive + negative)) / (1 + 3.8416 / (positive + negative))
        AS ci_lower_bound
      FROM resources
      WHERE positive + negative > 0
      ORDER BY ci_lower_bound DESC']
  end


  def to_param
    url
  end

  def resource_icon

    if self.resource_type.downcase == "pdf"
      icon_to_show = "fa fa-file-pdf-o"
    elsif self.resource_type.downcase == "document"
      icon_to_show = "fa fa-file-word-o"
    elsif self.resource_type.downcase == "spreadsheet"
      icon_to_show = "fa fa-file-excel-o"
    elsif self.resource_type.downcase == "image"
      icon_to_show = "fa fa-file-picture-o"
    elsif self.resource_type.downcase == "csv"
      icon_to_show = "fa fa-table"
    elsif self.resource_type.downcase == "geojson"
      icon_to_show = "fa fa-map-marker"
    else
      icon_to_show = "fa fa-file-o"
    end

    return icon_to_show
  end

  def can_edit(user)
    return false if user.nil?
    if !self.organization.nil?
      user_org = UsersOrganization.find_by :user_id => user.id, :organization_id => self.organization.id
    end

    if (!user_org.nil? and (user_org.role == :editor or user_org.role == :admin or user_org.role == "editor" or user_org.role == "admin")) or (self.author == user) or (user.can? :moderate, self)
      return true
    else
      return false
    end
  end

  def can_add_resources(user)
    return false if user.nil? || self.organization.nil?
    user_org = UsersOrganization.where("user_id = ?", user.id).where("organization_id = ?", self.organization.id)
    if (!user_org.nil? and (user_org.role == :editor or user_org.role == :admin or user_org.role == "editor" or user_org.role == "admin")) or (self.author == user)
      return true
    else
      return false
    end
  end

  def source_url_valid?
    # call this from controller before trying to redirect to source url
    if !self.source.nil?
      return self.valid_url?(self.source)
    else
      return false
    end
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end



  def handle_file_type
    word_types = ["application/msword","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/vnd.ms-word.document.macroEnabled.12","application/vnd.ms-word.template.macroEnabled.12","application/rtf"]
    excel_types = ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.openxmlformats-officedocument.spreadsheetml.template","application/vnd.ms-excel.sheet.macroEnabled.12","application/vnd.ms-excel.template.macroEnabled.12","application/vnd.ms-excel.sheet.binary.macroEnabled.12"]
    power_point_types = ["application/vnd.ms-powerpoint","application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.openxmlformats-officedocument.presentationml.template","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint.presentation.macroEnabled.12"]
    image_types = ["image/bmp","image/gif","image/jpg","image/jpeg","image/jpe","image/tiff","image/png"]
    text_types = ["text/plain"]
    geojson_types = ["application/vnd.geo+json"]

    self.resource_type = "Other"
    if self.attachment_content_type == 'text/csv' || self.attachment_content_type == 'text/comma-separated-values'
      self.resource_type = "CSV"
    elsif self.attachment_content_type == 'application/pdf'
      self.resource_type = "PDF"
    elsif word_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "Document"
    elsif power_point_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "Presentation"
    elsif excel_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "Spreadsheet"
    elsif image_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "Image"
    elsif text_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "Text"
    elsif geojson_types.select { |a| a == self.attachment_content_type }.length > 0
      self.resource_type = "GeoJSON"
    else
      if self.attachment_content_type == "application/octetstream"
        # try to get file type from extension
        if File.extname(self.attachment_file_name) == ".pdf"
          self.resource_type = "PDF"
        else
          logger.debug 'resource file extension: ' + File.extname(self.attachment_file_name)
        end
      else
        self.resource_type = "Other"

        # need to handle geojson files


        if !self.attachment_content_type.nil?
          #output unhandled file type to console
          logger.debug 'resource type: ' + self.attachment_content_type
        end

      end
    end

    logger.debug 'resource type set to: ' + self.resource_type

  end

def self.search_kmp(search_terms=nil, tags=nil, org=nil, language=nil, days_back=nil, only_approved=true, exclude_private=true)
  target_date = Date.today - days_back.to_i if !days_back.nil?
  query = "
    WITH resources_search AS (
      SELECT 
        r.id,
        r.updated_at,
        setweight(to_tsvector('english', r.name), 'A') || 
        setweight(to_tsvector('english', r.description), 'B') as document
      FROM resources r 
      WHERE r.cop_private = false "
      query = query + " AND r.approved = true " if only_approved
      query = query + " AND r.private = false " if exclude_private
      query = query + "
    ),
    filtered_resources_tags AS (
      SELECT r.id 
      FROM resources r 
      INNER JOIN taggings tg on r.id = tg.taggable_id and tg.taggable_type = 'Resource'
      INNER JOIN tags t on tg.tag_id = t.id"
      query = query + "
      WHERE 0=0 "
      query = query + " AND r.organization_id = " + org.to_s if !org.nil? 
      query = query + " AND r.language = '" + language + "'" if !language.nil? && language.length > 0
      query = query + " AND r.updated_at > '" + target_date.to_s + "'" if !days_back.nil?
      query = query + " AND tg.tag_id IN (" + tags.join(",") + ")" if !tags.nil? && tags.length > 0
      query = query + " GROUP BY r.id "
      query = query + " HAVING COUNT( r.id )=" + tags.length.to_s if !tags.nil? && tags.length > 0
      query = query + "
    )
    SELECT 
      rs.id,
      rs.updated_at
    FROM resources_search rs
    INNER JOIN filtered_resources_tags frt on rs.id = frt.id
    WHERE 0=0 "
    if !search_terms.nil? && search_terms.length > 0
      query = query + " AND rs.document @@ to_tsquery('english', '" + search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') + "')"
      query = query + " ORDER BY ts_rank(rs.document, to_tsquery('english', '" + search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') + "')) DESC"
    else
      query = query + " ORDER BY rs.updated_at DESC"
    end

    results = Resource.find_by_sql(query)
    ids = results.map { |r| r.id }
    count = ids.length

    return {ids: ids, count: count }
  end

  def self.search_tags(search_terms=nil, tags=nil, org=nil, language=nil, days_back=nil, only_approved=true, exclude_private=true)
    target_date = Date.today - days_back.to_i if !days_back.nil?
    query = "
    WITH resources_search AS (
      SELECT 
        r.id,
        setweight(to_tsvector('english', r.name), 'A') || 
        setweight(to_tsvector('english', r.description), 'B') as document
      FROM resources r 
      WHERE r.cop_private = false "
      query = query + " AND r.approved = true " if only_approved
      query = query + " AND r.private = false " if exclude_private
      query = query + "
    ),
    filtered_resources_tags AS (
      SELECT r.id 
      FROM resources r 
      INNER JOIN taggings tg on r.id = tg.taggable_id and tg.taggable_type = 'Resource'
      INNER JOIN tags t on tg.tag_id = t.id"
      query = query + "
      WHERE 0=0 "
      query = query + " AND r.organization_id = " + org.to_s if !org.nil? 
      query = query + " AND r.updated_at > '" + target_date.to_s + "'" if !days_back.nil?
      query = query + " AND r.language = '" + language + "'" if !language.nil?  && language.length > 0
      query = query + " AND tg.tag_id IN (" + tags.join(",") + ")" if !tags.nil? && tags.length > 0
      query = query + " GROUP BY r.id "
      query = query + " HAVING COUNT( r.id )=" + tags.length.to_s if !tags.nil? && tags.length > 0
      query = query + "
    )
    SELECT 
      t.id, 
      t.name,
      tt.name as tag_type,
      tt.id as tag_type_id,
      count(t.id) as tag_count
    FROM resources_search rs
    INNER JOIN filtered_resources_tags frt on rs.id = frt.id
    INNER JOIN taggings tg on rs.id = tg.taggable_id and tg.taggable_type = 'Resource'
    INNER JOIN tags t on tg.tag_id = t.id
    INNER JOIN tag_types tt on t.tag_type_id = tt.id
    WHERE 0=0 "
    if !search_terms.nil? && search_terms.length > 0
      query = query + " AND rs.document @@ to_tsquery('english', '" + search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') + "')"
    end
    query = query + " GROUP BY t.name, t.id, tt.name, tt.id ORDER BY tt.name, t.name desc"

    results = ActiveRecord::Base.connection.exec_query(query)

    grouped_results = results.group_by { |r| r["tag_type"] }

    return grouped_results
  end

  def self.search_orgs(search_terms=nil, tags=nil, language=nil, days_back=nil, only_approved=true, exclude_private=true)
    target_date = Date.today - days_back.to_i if !days_back.nil?
    query = "
    WITH resources_search AS (
      SELECT 
        r.id,
        r.organization_id,
        setweight(to_tsvector('english', r.name), 'A') || 
        setweight(to_tsvector('english', r.description), 'B') as document
      FROM resources r 
      WHERE r.cop_private = false "
      query = query + " AND r.approved = true " if only_approved
      query = query + " AND r.private = false " if exclude_private
      query = query + "
    ),
    filtered_resources_tags AS (
      SELECT r.id 
      FROM resources r 
      INNER JOIN taggings tg on r.id = tg.taggable_id and tg.taggable_type = 'Resource'
      INNER JOIN tags t on tg.tag_id = t.id"
      query = query + "
      WHERE 0=0 "
      query = query + " AND r.updated_at > '" + target_date.to_s + "'" if !days_back.nil?
      query = query + " AND r.language = '" + language + "'" if !language.nil?  && language.length > 0
      query = query + " AND tg.tag_id IN (" + tags.join(",") + ")" if !tags.nil? && tags.length > 0
      query = query + " GROUP BY r.id "
      query = query + " HAVING COUNT( r.id )=" + tags.length.to_s if !tags.nil? && tags.length > 0
      query = query + "
    )
    SELECT 
      o.id, 
      o.name,
      count(distinct rs.id) as org_count
    FROM resources_search rs
    INNER JOIN organizations o on rs.organization_id = o.id
    INNER JOIN filtered_resources_tags frt on rs.id = frt.id
    INNER JOIN taggings tg on rs.id = tg.taggable_id and tg.taggable_type = 'Resource'
    INNER JOIN tags t on tg.tag_id = t.id
    WHERE 0=0 "
    if !search_terms.nil? && search_terms.length > 0
      query = query + " AND rs.document @@ to_tsquery('english', '" + search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') + "')"
    end
    query = query + " GROUP BY o.name, o.id ORDER BY org_count desc"

    results = ActiveRecord::Base.connection.exec_query(query)

    return results.to_ary
  end


  private

  def scan_for_viruses
    path = self.attachment.url
    scan_result = Clamby.safe?(path)

    puts 'scan_result = ' + scan_result.to_s
    if scan_result
      return true

    end
  end

  def attachment_or_source
    if self.attachment.blank? and self.source.blank?
      errors.add(:base, "Either a File attachment or a Source URL are required")
    end
  end


end
