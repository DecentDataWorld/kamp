class UserTypesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :only => [:edit, :update, :destroy]
  before_action :set_user_type, only: [:show, :edit, :update, :destroy]

  # GET /user_types
  # GET /user_types.json
  def index
    @page_title = "Manage User Types"
    add_crumb 'Administration', admin_index_path
    @user_types = UserType.all
  end

  # GET /user_types/1
  # GET /user_types/1.json
  def show
    @page_title = "View User Type"
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage User Types', user_types_path
  end

  # GET /user_types/new
  def new
    @page_title = "Add User Type"
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage User Types', user_types_path
    @user_type = UserType.new
  end

  # GET /user_types/1/edit
  def edit
    @page_title = "Edit User Type"
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage User Types', user_types_path
  end

  # POST /user_types
  # POST /user_types.json
  def create
    @user_type = UserType.new(user_type_params)

    respond_to do |format|
      if @user_type.save
        format.html { redirect_to user_types_path, notice: 'User type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_types/1
  # PATCH/PUT /user_types/1.json
  def update
    respond_to do |format|
      if @user_type.update(user_type_params)
        format.html { redirect_to user_types_path, notice: 'User type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_types/1
  # DELETE /user_types/1.json
  def destroy
    @user_type.destroy
    respond_to do |format|
      format.html { redirect_to user_types_url }
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
    def set_user_type
      @user_type = UserType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_type_params
      params.require(:user_type).permit(:user_type)
    end
end
