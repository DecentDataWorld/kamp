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
      @search.organization_id = params[:organization_id]
    else
      @search.organization_id = nil
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

    if !@search.organization_id.blank?
      params[:organization_id] = @search.organization_id
    end

    if !@search.tags.nil?
      params[:tags] = @search.tags
    end

  end

  def get_pg_results
    if params[:query] || params[:tags] || params[:organization_id]
      resource_results = Resource.search_kmp(params[:query], params[:tags], params[:organization_id])
      @resource_count = resource_results[:count]
      @resources = Resource.where(id: resource_results[:ids]).order("updated_at desc").paginate(page: params[:page], per_page: 10)
      @tags = Resource.search_tags(params[:query], params[:tags], params[:organization_id])
      @orgs = []
      if !params[:organization_id]
        @orgs = Resource.search_orgs(params[:query], params[:tags])
      end

      collection_results = Collection.search_kmp(params[:query], params[:tags], params[:organization_id])
      @collection_count = collection_results[:count]
      @collections = Collection.where(id: collection_results[:ids]).order("updated_at desc").paginate(page: params[:collection_page], per_page: 10)
    else
      @resources = Resource.where(:private => false).where(:approved => true).order("updated_at desc").paginate(page: params[:page], per_page: 10)
      @resource_count = Resource.where(:private => false).where(:approved => true).length
      @tags = Resource.search_tags
      @orgs = Resource.search_orgs

      @collections = Collection.where(:private => false).where(:approved => true).order("updated_at desc").paginate(page: params[:collection_page], per_page: 10)
    end
    
  end

end
