require 'json'
class FeaturedSearchesController < ApplicationController
    before_action :set_featured_search, only: [:edit, :update, :destroy]
  
    # GET /featured_searches
    # GET /featured_searches.json
    def index
      @featured_searches = FeaturedSearch.order(:name)
      
      respond_to do |format|
        format.html
        format.json { render json: @featured_searches.order(:name), status: :ok }
      end
    end
  
    # GET /featured_searches/new
    def new
      @featured_search = FeaturedSearch.new
      @grouped_tags = TagType.grouped_tags
    end
  
    # GET /featured_searches/1/edit
    def edit
      @grouped_tags = TagType.grouped_tags
    end
  
    # POST /featured_searches
    # POST /featured_searches.json
    def create
      @featured_search = FeaturedSearch.new(featured_search_params)
      @featured_search.tag_list = params[:featured_search][:tags]
  
      respond_to do |format|
        if @featured_search.save
          flash[:notice] = I18n.t("notices.create_success")
          format.html { redirect_to featured_searches_path }
          format.json { render :show, status: :created, location: @featured_search }
        else
          format.html { render :new }
          format.json { render json: @featured_search.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /featured_searches/1
    # PATCH/PUT /featured_searches/1.json
    def update
      @featured_search.tag_list = params[:featured_search][:tags]
      respond_to do |format|
        if @featured_search.update(featured_search_params)
          flash[:notice] = I18n.t("notices.update_success")
          format.html { redirect_to featured_searches_path  }
          format.json { render :show, status: :ok, location: @featured_search }
        else
          format.html { render :edit }
          format.json { render json: @featured_search.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /featured_searches/1
    # DELETE /featured_searches/1.json
    def destroy
      respond_to do |format|
        @featured_search.destroy
        flash[:notice] = I18n.t("notices.delete_success")
        format.html { redirect_to featured_searches_path }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_featured_search
        @featured_search = FeaturedSearch.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def featured_search_params
        params.require(:featured_search).permit(:name, :icon_identifier, :tag_list, :cop_id)
      end
  end
  