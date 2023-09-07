class OrganizationTypesController < ApplicationController
  #before_action :authenticate_user!
  load_and_authorize_resource :only => [:edit, :update, :destroy]
  before_action :set_organization_type, only: [:show, :edit, :update, :destroy]
  before_action :authorized?

  # GET /organization_types
  # GET /organization_types.json
  def index
    @page_title = "Manage Organization Types"
    add_crumb 'Administration', admin_index_path
    @organization_types = OrganizationType.all
  end

  # GET /organization_types/1
  # GET /organization_types/1.json
  def show
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Organization Types', organization_types_path
  end

  # GET /organization_types/new
  def new
    @page_title = "Add Organization Type"
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Organization Types', organization_types_path
    @organization_type = OrganizationType.new
  end

  # GET /organization_types/1/edit
  def edit
    @page_title = "Edit Organization Type"
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Organization Types', organization_types_path
  end

  # POST /organization_types
  # POST /organization_types.json
  def create
    @organization_type = OrganizationType.new(organization_type_params)

    respond_to do |format|
      if @organization_type.save
        format.html { redirect_to organization_types_path, notice: 'Organization type was successfully created.' }
        format.json { render :show, status: :created, location: @organization_type }
      else
        format.html { render :new }
        format.json { render json: @organization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organization_types/1
  # PATCH/PUT /organization_types/1.json
  def update
    respond_to do |format|
      if @organization_type.update(organization_type_params)
        format.html { redirect_to organization_types_path, notice: 'Organization type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_types/1
  # DELETE /organization_types/1.json
  def destroy
    @organization_type.destroy
    respond_to do |format|
      format.html { redirect_to organization_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_type
      @organization_type = OrganizationType.find(params[:id])
    end

    def authorized?
      unless (can? :manage, :all)
        flash[:error] = "You are not authorized to view that page."
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_type_params
      params.require(:organization_type).permit(:organization_type)
    end
end
