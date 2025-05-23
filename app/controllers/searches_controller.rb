class SearchesController < ApplicationController
  def index
    redirect_to root_path
  end

  def new
    @search = Search.new

    if !params[:collection_page].nil? && session[:collection_page] != params[:collection_page]
      @show_collections = true
    else
      @show_collections = false
    end

    session[:page] = params[:page] || nil
    session[:collection_page] = params[:collection_page] || nil

    get_pg_results
  end

  def create
    @search = Search.create!(:query => params[:query])
    update_search_attributes

    redirect_to @search
  end

  def show
    @search = Search.find(params[:id])
    session[:last_search_id] = @search.id.to_s

    if !params[:collection_page].nil? && session[:collection_page] != params[:collection_page]
      @show_collections = true
    else
      @show_collections = false
    end

    session[:page] = params[:page] || nil
    session[:collection_page] = params[:collection_page] || nil

    update_params_with_search

    @last_filter_choice = session[:last_filter_choice].blank? ? 'tags' : session[:last_filter_choice]

    get_pg_results
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
      if params[:organization_id].length > 0 && params[:organization_id].to_i != @search.organization_id
        session[:last_filter_choice] = 'orgs'
      end
      @search.organization_id = params[:organization_id]
    else
      @search.organization_id = nil
    end

    if !params[:language].nil?
      if params[:language].length > 0 && params[:language] != @search.language
        session[:last_filter_choice] = 'other'
      end
      @search.language = params[:language]
    else
      @search.language = nil
    end

    if !params[:days_back].nil?
      if params[:days_back].length > 0 && params[:days_back].to_i != @search.days_back
        session[:last_filter_choice] = 'other'
      end
      @search.days_back = params[:days_back]
    else
      @search.days_back = nil
    end

    if !params[:tags].nil?
      if params[:tags].length > 0 && params[:tags] != @search.tags
        session[:last_filter_choice] = 'tags'
      end
      @search.tags = params[:tags]
    else
      @search.tags = nil
    end

    if !params[:cop_id].nil?
      if params[:cop_id].length > 0 && params[:cop_id].to_i != @search.cop_id
        session[:last_filter_choice] = 'cops'
      end
      @search.cop_id = params[:cop_id]
    else
      @search.cop_id = nil
    end

    if params[:organization_id].blank? && params[:language].blank? && params[:days_back].blank? && params[:tags].blank? && params[:cop_id].blank?
      session[:last_filter_choice] = 'tags'
    end

    @search.save
  end

  def update_params_with_search
    if !@search.query.nil?
      params[:query] = @search.query
    end

    if !@search.organization_id.blank?
      params[:organization_id] = @search.organization_id
    end

    if !@search.language.blank?
      params[:language] = @search.language
    end

    if !@search.days_back.blank?
      params[:days_back] = @search.days_back
    end

    if !@search.tags.nil?
      params[:tags] = @search.tags
    end

    if !@search.cop_id.blank?
      params[:cop_id] = @search.cop_id
    end

  end

  def get_pg_results
    params[:query] = params[:query] && params[:query].length > 0 ? params[:query] : nil
    @search_terms = params[:query] || ''
    @language = params[:language] || nil
    @days_back = params[:days_back] || nil
    @languages = {:arabic => 'Arabic', :english => 'English'}
    @days_backs = {7 => 'Less Than a Week Ago', 30 => 'Less Than a Month Ago', 183 => 'Less Than Six Months Ago', 365 => 'Less Than a Year Ago'}

    resource_results = Resource.search_kmp(params[:query], params[:tags], params[:organization_id], params[:cop_id], params[:language], params[:days_back])
    resource_ids = resource_results[:ids]
    @resource_count = resource_results[:count]
    @resources = Resource.where(id: resource_ids).order(Arel.sql("array_position(ARRAY[#{resource_ids.join(',')}], resources.id)")).paginate(page: params[:page], per_page: 10)
    @tags = Resource.resource_tags(resource_ids)
    @orgs = []
    @organization = nil
    if params[:organization_id].present? and Organization.where(id: params[:organization_id]).exists?
      @organization =  Organization.find(params[:organization_id])
    else
      @orgs = Resource.resource_orgs(resource_ids)
    end

    @cops = []
    @cop = nil
    if params[:cop_id].present? and Cop.where(id: params[:cop_id]).exists?
      @cop =  Cop.find(params[:cop_id])
    else
      @cops = Resource.resource_cops(resource_ids)
    end

    collection_results = Collection.search_kmp(params[:query], params[:tags], params[:organization_id], params[:cop_id], params[:days_back])
    @collection_count = collection_results[:count]
    @collections = Collection.where(id: collection_results[:ids]).order(Arel.sql("array_position(ARRAY[#{collection_results[:ids].join(',')}], collections.id)")).paginate(page: params[:collection_page], per_page: 10)

  end

end
