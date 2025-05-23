class TagTypesController < ApplicationController
    before_action :set_tag_type, only: [:edit, :update, :destroy]
    before_action :authorized?
  
    # GET /tag_types
    # GET /tag_types.json
    def index
      @tag_types = TagType.order(:name)
      
      respond_to do |format|
        format.html
        format.json { render json: @tag_types.order(:name), status: :ok }
      end
    end
  
    # GET /tag_types/new
    def new
      @tag_type = TagType.new
    end
  
    # GET /tag_types/1/edit
    def edit
    end
  
    # POST /tag_types
    # POST /tag_types.json
    def create
      @tag_type = TagType.new(tag_type_params)
  
      respond_to do |format|
        if @tag_type.save
          flash[:notice] = I18n.t("notices.create_success")
          format.html { redirect_to tag_types_path }
          format.json { render :show, status: :created, location: @tag_type }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @tag_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /tag_types/1
    # PATCH/PUT /tag_types/1.json
    def update
      respond_to do |format|
        if @tag_type.update(tag_type_params)
          flash[:notice] = I18n.t("notices.update_success")
          format.html { redirect_to tag_types_path  }
          format.json { render :show, status: :ok, location: @tag_type }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @tag_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /tag_types/1
    # DELETE /tag_types/1.json
    def destroy
      respond_to do |format|
        if @tag_type.tags.count > 0
          flash[:error] = "Tag Type has associated Tags and cannot be deleted."
          format.html { redirect_back(fallback_location: edit_tag_type_path(@tag_type)) }
          format.json { render json: @tag_type.errors, status: :unprocessable_entity}
        else
          if @tag_type.destroy
            flash[:notice] = I18n.t("notices.delete_success")
            format.html { redirect_to tag_types_path }
            format.json { head :no_content }
          else
            flash[:notice] = I18n.t("notices.delete_failure")
            format.html { render :edit }
            format.json { render json: @tag_type.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tag_type
        @tag_type = TagType.find(params[:id])
      end

      def authorized?
        unless (can? :manage, :all)
          flash[:error] = "You are not authorized to view that page."
          redirect_to root_path
        end
      end
  
      # Only allow a list of trusted parameters through.
      def tag_type_params
        params.require(:tag_type).permit(:name)
      end
  end
  