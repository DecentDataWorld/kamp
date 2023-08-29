class TagsController < ApplicationController
    before_action :set_tag, only: [:edit, :update, :destroy]
    before_action :authorized?
  
    # GET /tags
    # GET /tags.json
    def index
      @tags = Tag.includes(:tag_type).order(:name)
  
      respond_to do |format|
        format.html
        format.json { render json: @tags.order(:name), status: :ok }
      end
    end
  
    def grouped_tags
      @tags = Tag.grouped_tags
      render json: @tags, status: :ok
    end
  
  
    # GET /tags/new
    def new
      @tag = Tag.new
    end
  
    # GET /tags/1/edit
    def edit
    end
  
    # POST /tags
    # POST /tags.json
    def create
      @tag = Tag.new(tag_params)
  
      respond_to do |format|
        if @tag.save
          flash[:notice] = I18n.t("notices.create_success")
          format.html { redirect_to tags_path }
          format.json { render :show, status: :created, location: @tag }
        else
          format.html { render :new }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /tags/1
    # PATCH/PUT /tags/1.json
    def update
      respond_to do |format|
        if @tag.update(tag_params)
          flash[:notice] = I18n.t("notices.update_success")
          format.html { redirect_to tags_path }
          format.json { render :show, status: :ok, location: @tag }
        else
          format.html { render :edit }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /tags/1
    # DELETE /tags/1.json
    def destroy
      respond_to do |format|
        if @tag.destroy
          flash[:notice] = I18n.t("notices.delete_success")
          format.html { redirect_to tags_path }
          format.json { head :no_content }
        else
          format.html { render :edit }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tag
        @tag = Tag.find(params[:id])
      end

      def authorized?
        unless (can? :dashboard, current_user)
          flash[:error] = "You are not authorized to view that page."
          redirect_to root_path
        end
      end
  
      # Only allow a list of trusted parameters through.
      def tag_params
        params.require(:tag).permit(:name, :tag_type_id)
      end
  end
  