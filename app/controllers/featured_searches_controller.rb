require 'json'
class FeaturedSearchesController < ApplicationController
    before_action :set_featured_search, only: [:edit, :update, :destroy]
    before_action :authorized?
  
    # GET /featured_searches
    # GET /featured_searches.json
    def index
      if can? :manage, :all
        @featured_searches = FeaturedSearch.order(:name)
      else
        cop_ids = Cop.where(:admin_id => current_user.id).pluck(:id)
        @featured_searches = FeaturedSearch.where(:cop_id => cop_ids).order(:name)
      end
      
      
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
          format.html { render :new, status: :unprocessable_entity }
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
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @featured_search.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /featured_searches/1
    # DELETE /featured_searches/1.json
    def destroy
      respond_to do |format|
        if @featured_search.destroy
          flash[:notice] = I18n.t("notices.delete_success")
          format.html { redirect_to featured_searches_path }
          format.json { head :no_content }
        else
          flash[:notice] = I18n.t("notices.delete_failure")
          format.html { redirect_back(fallback_location: featured_searches_path) }
          format.json { render json: @featured_search.errors, status: :unprocessable_entity }
        end
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_featured_search
        @featured_search = FeaturedSearch.find(params[:id])
      end

      def authorized?
        unless (can? :manage, :all) || current_user.cop_admin?
          flash[:error] = "You are not authorized to view that page."
          redirect_to root_path
        end
      end
  
      # Only allow a list of trusted parameters through.
      def featured_search_params
        params.require(:featured_search).permit(:name, :icon_identifier, :tag_list, :cop_id)
      end
  end
  