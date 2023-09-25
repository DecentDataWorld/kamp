class CopsController < ApplicationController
  before_action :set_cop, only: [:edit, :update, :destroy, :show, :show_cop]
  before_action :authorized?, except: [:show_cop]

  # GET /admin/cops
  # GET /admin/cops.json
  def index
    if can? :manage, :all
      @cops = Cop.order(:name)
    else
      cop_ids = Cop.where(:admin_id => current_user.id).pluck(:id)
      @cops = Cop.where(:id => cop_ids).order(:name)
    end

    respond_to do |format|
      format.html
      format.json { render json: @cops.order(:name), status: :ok }
    end
  end


  # GET /admin/cops/new
  def new
    @cop = Cop.new
  end

  # GET /admin/cops/1/edit
  def edit
  end

  # GET /admin/admin/cops/1
  def show
  end

  # GET /cops/1
  def show_cop
  end

  # POST /admin/cops
  # POST /admin/cops.json
  def create
    @cop = Cop.new(cop_params)

    respond_to do |format|
      if @cop.save
        flash[:notice] = I18n.t("notices.create_success")
        format.html { redirect_to cops_path }
        format.json { render :show, status: :created, location: @cop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/cops/1
  # PATCH/PUT /admin/cops/1.json
  def update
    respond_to do |format|
      if @cop.update(cop_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to cops_path }
        format.json { render :show, status: :ok, location: @cop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/cops/1
  # DELETE /admin/cops/1.json
  def destroy
    respond_to do |format|
      if @cop.destroy
        flash[:notice] = I18n.t("notices.delete_success")
        format.html { redirect_to cops_path }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @cop.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cop
      @cop = Cop.find(params[:id])
    end

    def authorized?
      unless (can? :manage, :all) || current_user.cop_admin?
        flash[:error] = "You are not authorized to view that page."
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def cop_params
      params.require(:cop).permit(:name, :description, :admin_id, :user_ids => [], :resource_ids => [])
    end
  end
  