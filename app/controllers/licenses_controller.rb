class LicensesController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :only => [:edit, :update, :destroy]
  before_action :set_license, only: [:show, :edit, :update, :destroy]
  before_action :authorized?

  # GET /licenses
  # GET /licenses.json
  def index
    add_crumb 'Administration', admin_index_path
    @page_title = "Manage Licenses"
    @licenses = License.all
  end

  # GET /licenses/1
  # GET /licenses/1.json
  def show
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Licenses', licenses_path
    @page_title = "View License"
  end

  # GET /licenses/new
  def new
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Licenses', licenses_path
    @page_title = "Add License"
    @license = License.new
  end

  # GET /licenses/1/edit
  def edit
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Licenses', licenses_path
    @page_title = "Edit License"
  end

  # POST /licenses
  # POST /licenses.json
  def create
    @license = License.new(license_params)

    respond_to do |format|
      if @license.save
        format.html { redirect_to @license, notice: 'License was successfully created.' }
        format.json { render action: 'show', status: :created, location: @license }
      else
        format.html { render action: 'new' }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /licenses/1
  # PATCH/PUT /licenses/1.json
  def update
    respond_to do |format|
      if @license.update(license_params)
        format.html { redirect_to @license, notice: 'License was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @license.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
    @license.destroy
    respond_to do |format|
      format.html { redirect_to licenses_url }
      format.json { head :no_content }
    end
  end

  private

  def authorized?
    unless can? :dashboard, current_user
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_license
      @license = License.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def license_params
      params.require(:license).permit(:name)
    end
end
