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
  belongs_to :activity, :class_name => "Activity", :foreign_key => "activity_id"
  belongs_to :collection, :class_name => "Collection", :foreign_key => "collection_id"
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  belongs_to :organization, :class_name => "Organization", :foreign_key => "organization_id"
  belongs_to :license, :class_name => "License", :foreign_key => "license_id"
  belongs_to :batch, :class_name => "Batch", :foreign_key => "batch_id"

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment

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

  searchable do
    text :name, :url
    text :description
    boolean :newsletter_only
    string :resource_type
    string :language
    boolean :private
    integer :author_id, :references => User
    integer :collection_id, :references => Collection
    integer :organization_id, :references => Organization
    integer :license_id, :references => License
    string :tags, :multiple => true do
      tags.map { |p| p.name}
    end
    boolean :approved
    time :created_at
    time :updated_at
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
