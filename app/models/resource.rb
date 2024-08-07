class Resource < ActiveRecord::Base
  extend Enumerize

  attr_accessor :reason

  acts_as_taggable
  acts_as_url :name

  enumerize :status, in: [:active, :inactive], default: :active
  enumerize :resource_type, in: ["Other", "CSV", "PDF", "Document", "Spreadsheet", "GeoJSON", "Presentation", "Image", "Text"], default: "Other"
  enumerize :language, in: [:english, :arabic], default: :english

  is_impressionable counter_cache: true, unique: true

  validates :name, presence: { message: "Name is required" }
  validates :description, presence: { message: "A description of this resource is required" }
  validates :resource_type, presence: { message: "Choose a resource type" }
  validates :tag_list, presence: { message: "Choose at least one tag" }
  validate :attachment_or_source

  belongs_to :activity, class_name: "Activity", foreign_key: "activity_id", optional: true
  belongs_to :collection, class_name: "Collection", foreign_key: "collection_id", optional: true
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :organization, class_name: "Organization", foreign_key: "organization_id"
  belongs_to :license, class_name: "License", foreign_key: "license_id", optional: true
  belongs_to :batch, class_name: "Batch", foreign_key: "batch_id", optional: true
  belongs_to :cop, class_name: "Cop", foreign_key: "cop_id", optional: true

  has_many :resourcings
  has_many :collections, through: :resourcings, source: :resourceable, source_type: 'Collection'
  has_and_belongs_to_many :cops

  has_attached_file :attachment, validate_media_type: false
  do_not_validate_attachment_file_type :attachment

  def to_param
    url
  end

  def resource_icon
    case self.resource_type.downcase
    when "pdf" then "fa fa-file-pdf-o"
    when "document" then "fa fa-file-word-o"
    when "spreadsheet" then "fa fa-file-excel-o"
    when "image" then "fa fa-file-picture-o"
    when "csv" then "fa fa-table"
    when "geojson" then "fa fa-map-marker"
    else "fa fa-file-o"
    end
  end

  def can_edit(user)
    return false unless user
    user_org = UsersOrganization.find_by(user_id: user.id, organization_id: self.organization_id) if self.organization
    user_org&.role.in?(["editor", "admin"]) || self.author == user || user.can?(:moderate, self)
  end

  def can_add_resources(user)
    return false unless user && self.organization
    user_org = UsersOrganization.where(user_id: user.id, organization_id: self.organization_id)
    user_org&.role.in?(["editor", "admin"]) || self.author == user
  end

  def source_url_valid?
    self.source && valid_url?(self.source)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def handle_file_type
    word_types = ["application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.ms-word.document.macroEnabled.12", "application/vnd.ms-word.template.macroEnabled.12", "application/rtf"]
    excel_types = ["application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.openxmlformats-officedocument.spreadsheetml.template", "application/vnd.ms-excel.sheet.macroEnabled.12", "application/vnd.ms-excel.template.macroEnabled.12", "application/vnd.ms-excel.sheet.binary.macroEnabled.12"]
    power_point_types = ["application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.openxmlformats-officedocument.presentationml.template", "application/vnd.openxmlformats-officedocument.presentationml.slideshow", "application/vnd.ms-powerpoint.presentation.macroEnabled.12"]
    image_types = ["image/bmp", "image/gif", "image/jpg", "image/jpeg", "image/jpe", "image/tiff", "image/png"]
    text_types = ["text/plain"]
    geojson_types = ["application/vnd.geo+json"]

    self.resource_type = case self.attachment_content_type
    when 'text/csv', 'text/comma-separated-values' then "CSV"
    when 'application/pdf' then "PDF"
    when *word_types then "Document"
    when *power_point_types then "Presentation"
    when *excel_types then "Spreadsheet"
    when *image_types then "Image"
    when *text_types then "Text"
    when *geojson_types then "GeoJSON"
    when 'application/octetstream'
      File.extname(self.attachment_file_name) == ".pdf" ? "PDF" : "Other"
    else
      "Other"
    end
  end

  def self.search_kmp(search_terms = nil, tags = nil, org = nil, cop = nil, language = nil, days_back = nil, only_approved = true, exclude_private = true, exclude_cop_private = true)
    target_date = Date.today - days_back.to_i if days_back
    search_query = search_terms ? search_terms.gsub('&', ' ').gsub('|', ' ').split(' ').join(' & ') : nil
    tag_ids = tags ? tags.join(",") : nil

    conditions = []
    conditions << "r.approved = true" if only_approved
    conditions << "r.private = false" if exclude_private
    conditions << "r.cop_private = false" if exclude_cop_private

    tags_conditions = []
    tags_conditions << "r.organization_id = #{org}" if org
    tags_conditions << "r.cop_id = #{cop}" if cop
    tags_conditions << "r.updated_at > '#{target_date}'" if days_back
    tags_conditions << "r.language = '#{language}'" if language
    tags_conditions << "tg.tag_id IN (#{tag_ids}) GROUP BY r.id HAVING COUNT(r.id) = #{tags.length}" if tags

    query = <<-SQL
      WITH resources_search AS (
        SELECT
          r.id,
          r.updated_at,
          setweight(to_tsvector('english', r.name), 'A') ||
          setweight(to_tsvector('english', r.description), 'B') as document
        FROM resources r
        WHERE #{conditions.join(' AND ')}
      ),
      filtered_resources_tags AS (
        SELECT #{!tags ? "DISTINCT" : ""} r.id
        FROM resources r
        INNER JOIN taggings tg ON r.id = tg.taggable_id AND tg.taggable_type = 'Resource'
        INNER JOIN tags t ON tg.tag_id = t.id
        WHERE #{tags_conditions.any? ? tags_conditions.join(' AND ') : '1=1'}
      )
      SELECT
        rs.id,
        rs.updated_at
      FROM resources_search rs
      INNER JOIN filtered_resources_tags frt ON rs.id = frt.id
      #{search_query ? "WHERE rs.document @@ to_tsquery('english', '#{search_query}')" : ""}
      ORDER BY #{search_query ? "ts_rank(rs.document, to_tsquery('english', '#{search_query}')) DESC" : "rs.updated_at DESC"}
    SQL

    results = Resource.find_by_sql(query)
    ids = results.map(&:id)
    count = ids.length

    { ids: ids, count: count }
  end

  def self.resource_tags(resource_ids)
    query = <<-SQL
      SELECT
        t.id,
        t.name,
        tt.name AS tag_type,
        tt.id AS tag_type_id,
        COUNT(t.id) AS tag_count
      FROM resources r
      INNER JOIN taggings tg ON r.id = tg.taggable_id AND tg.taggable_type = 'Resource'
      INNER JOIN tags t ON tg.tag_id = t.id
      INNER JOIN tag_types tt ON t.tag_type_id = tt.id
      WHERE r.id IN (?)
      GROUP BY t.name, t.id, tt.name, tt.id
      ORDER BY tt.name, t.name DESC
    SQL

    sanitized_query = ActiveRecord::Base.sanitize_sql_array([query, resource_ids])
    results = ActiveRecord::Base.connection.exec_query(sanitized_query)
    grouped_results = results.group_by { |r| r["tag_type"] }

    grouped_results
  end

  def self.resource_orgs(resource_ids)
    query = <<-SQL
      SELECT
        o.id,
        o.name,
        COUNT(DISTINCT r.id) AS org_count
      FROM resources r
      INNER JOIN organizations o ON r.organization_id = o.id
      WHERE r.id IN (?)
      GROUP BY o.name, o.id
      ORDER BY org_count DESC
    SQL

    sanitized_query = ActiveRecord::Base.sanitize_sql_array([query, resource_ids])
    results = ActiveRecord::Base.connection.exec_query(sanitized_query)
    results.to_ary
  end

  def self.resource_cops(resource_ids)
    query = <<-SQL
      SELECT
        c.id,
        c.name,
        COUNT(DISTINCT r.id) AS cop_count
      FROM resources r
      INNER JOIN cops c ON r.cop_id = c.id
      WHERE r.id IN (?)
      GROUP BY c.name, c.id
      ORDER BY cop_count DESC
    SQL

    sanitized_query = ActiveRecord::Base.sanitize_sql_array([query, resource_ids])
    results = ActiveRecord::Base.connection.exec_query(sanitized_query)
    results.to_ary
  end

  def self.pending_count
    Resource.where(approved: false).count + Collection.where(approved: false).count
  end

  private

  def attachment_or_source
    if attachment.blank? && source.blank?
      errors.add(:base, "Either a File attachment or a Source URL are required")
    end
  end
end
