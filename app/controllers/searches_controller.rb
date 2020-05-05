class SearchesController < ApplicationController
  def index
    redirect_to root_path
  end

  def new

    @search = Search.new

    check_collections_only

    get_search_results

    puts '@collections_only = '+@collections_only.to_s

  end

  def create
    @search = Search.create!(:query => params[:query])
    update_search_attributes

    redirect_to @search
  end

  def show
    @search = Search.find(params[:id])
    session[:last_search_id] = @search.id.to_s

    check_collections_only

    update_params_with_search

    get_search_results
  end

  # PATCH/PUT /licenses/1
  # PATCH/PUT /licenses/1.json
  def update
    if !params[:id].nil?
      @search = Search.find(params[:id])
    else
      @search = Search.new
    end

    update_search_attributes

    redirect_to search_path(@search)
  end

  def update_search
    if !params[:id].nil?
      @search = Search.find(params[:id])
    else
      @search = Search.new
    end

    update_search_attributes

    redirect_to search_path(@search)

  end

  private

  def update_search_attributes
    if !params[:query].nil?
      @search.query = params[:query]
    end

    if !params[:organization_id].nil?
      @search.organization_id = params[:organization_id]
    else
      @search.organization_id = nil
    end

    if !params[:collections_only].nil? && (params[:collections_only] == true || params[:collections_only] == "true")
      @search.collections_only = true
    else
      @search.collections_only = false
    end

    if !params[:resources_only].nil? && (params[:resources_only] == true || params[:resources_only] == "true")
      @search.resources_only = true
    else
      @search.resources_only = false
    end

    if !params[:license_id].nil?
      @search.license_id = params[:license_id]
    else
      @search.license_id = nil
    end

    if !params[:resource_type].nil?
      @search.resource_type = params[:resource_type]
    else
      @search.resource_type = nil
    end

    if !params[:language].nil?
      @search.language = params[:language]
    else
      @search.language = nil
    end

    if !params[:tags].nil?
      @search.tags = params[:tags]
    else
      @search.tags = nil
    end

    @search.save

  end

  def update_params_with_search
    if !@search.query.nil?
      params[:query] = @search.query
    end

    if @search.collections_only == true
      params[:collections_only] = true
    else
      params[:collections_only] = false
    end

    if @search.resources_only == true
      params[:resources_only] = true
    else
      params[:resources_only] = false
    end

    if !@search.organization_id.blank?
      params[:organization_id] = @search.organization_id
    end

    if !@search.license_id.blank?
      params[:license_id] = @search.license_id
    end

    if !@search.resource_type.blank?
      params[:resource_type] = @search.resource_type
    end

    if !@search.language.blank?
      params[:language] = @search.language
    end

    if !@search.tags.nil?
      params[:tags] = @search.tags
    end

  end


  def get_search_results
    tags_array= params[:tags].split(",") unless params[:tags].blank?

    puts 'collections_only = '+@collections_only.to_s

    if @collections_only == true
      puts 'in collections_only = '+@collections_only.to_s
      @search_results = Sunspot.search Collection do
        # keyword search
        fulltext params[:query]

        # check to see if organization is being included in this search
        if params[:organization_id].present?
          with(:organization_id, params[:organization_id].to_i)
        end
        # we want to expose this as a facet
        facet :organization_id

        # check to see if license is being included in this search
        if params[:license_id].present?
          with(:license_id, params[:license_id].to_i)
        end
        # we want to expose this as a facet
        facet :license_id

        with(:private, false)
        with(:approved, true)

        if current_user.nil? || !current_user.mail_chimp_user
          with(:newsletter_only, false)
        end

        # tags, AND'd
        if params[:tags].present?
          all_of do
            params[:tags].each do |tag|
              with(:tags, tag)
            end
          end
        end

        facet :tags

        # set sort order
        if params[:order_by] == "Updated"
          order_by :updated_at, :desc
        elsif params[:order_by] == "Created"
          order_by :created_at, :desc
        else
          #default
          order_by :updated_at, :desc
        end

        # activate pagination after 5 results
        paginate :page => params[:page], :per_page => 10
      end
    elsif @search.resources_only == true
      @search_results = Sunspot.search Resource do
        # keyword search
        fulltext params[:query]

        # check to see if organization is being included in this search
        if params[:organization_id].present?
          with(:organization_id, params[:organization_id].to_i)
        end
        # we want to expose this as a facet
        facet :organization_id

        # check to see if license is being included in this search
        if params[:license_id].present?
          with(:license_id, params[:license_id].to_i)
        end
        # we want to expose this as a facet
        facet :license_id

        # check to see if resource type is being included in this search
        with(:resource_type).equal_to(params[:resource_type]) unless params[:resource_type].blank?

        # we want to expose resource type as a facet
        facet :resource_type

        # check to see if language is being included in this search
        with(:language).equal_to(params[:language]) unless params[:language].blank?

        # we want to expose language as a facet
        facet :language

        with(:private, false)
        with(:approved, true)

        if current_user.nil? || !current_user.mail_chimp_user
          with(:newsletter_only, false)
        end

        # tags, AND'd
        if params[:tags].present?
          all_of do
            params[:tags].each do |tag|
              with(:tags, tag)
            end
          end
        end

        facet :tags

        # set sort order
        if params[:order_by] == "Updated"
          order_by :updated_at, :desc
        elsif params[:order_by] == "Created"
          order_by :created_at, :desc
        else
          #default
          order_by :updated_at, :desc
        end

        # activate pagination after 5 results
        paginate :page => params[:page], :per_page => 10
        end
      else
        @search_results = Sunspot.search Resource, Collection do
        # keyword search
        fulltext params[:query]

        # check to see if organization is being included in this search
        if params[:organization_id].present?
          with(:organization_id, params[:organization_id].to_i)
        end
        # we want to expose this as a facet
        facet :organization_id

        # check to see if license is being included in this search
        if params[:license_id].present?
          with(:license_id, params[:license_id].to_i)
        end
        # we want to expose this as a facet
        facet :license_id

        # check to see if resource type is being included in this search
        with(:resource_type).equal_to(params[:resource_type]) unless params[:resource_type].blank?

        # we want to expose resource type as a facet
        facet :resource_type

        # check to see if language is being included in this search
        with(:language).equal_to(params[:language]) unless params[:language].blank?

        # we want to expose language as a facet
        facet :language

        with(:private, false)
        with(:approved, true)


        if current_user.nil? || current_user.mail_chimp_user == false
          puts "cannot see newsletter stuff"
          with(:newsletter_only, false)
        end

        # tags, AND'd
        if params[:tags].present?
          all_of do
            params[:tags].each do |tag|
              with(:tags, tag)
            end
          end
        end

        facet :tags

        # set sort order
        if params[:order_by] == "Updated"
          order_by :updated_at, :desc
        elsif params[:order_by] == "Created"
          order_by :created_at, :desc
        else
          #default
          order_by :updated_at, :desc
        end

        # activate pagination after 5 results
        paginate :page => params[:page], :per_page => 10
      end
    end


    # set this to a global variable that is used by many partials
    @resources = @search_results.results

    if !params[:license_id].nil?
      @license = License.find_by :id => params[:license_id]
    end

  end

  def check_collections_only
    if @search.collections_only == true || (params.has_key?(:collections_only) && (params[:collections_only] == true || params[:collections_only] == "true"))
      @collections_only = true
    else
      @collections_only = false
    end

  end

end
