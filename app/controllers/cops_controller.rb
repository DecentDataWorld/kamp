class CopsController < ApplicationController
  before_action :set_cop, only: [:edit, :update, :destroy]

  # GET /cops
  # GET /cops.json
  def index
    @cops = Cop.order(:name)

    respond_to do |format|
      format.html
      format.json { render json: @cops.order(:name), status: :ok }
    end
  end


  # GET /cops/new
  def new
    @cop = Cop.new
  end

  # GET /cops/1/edit
  def edit
  end

  # POST /cops
  # POST /cops.json
  def create
    @cop = Cop.new(cop_params)

    respond_to do |format|
      if @cop.save
        flash[:notice] = I18n.t("notices.create_success")
        format.html { redirect_to cops_path }
        format.json { render :show, status: :created, location: @cop }
      else
        format.html { render :new }
        format.json { render json: @cop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cops/1
  # PATCH/PUT /cops/1.json
  def update
    respond_to do |format|
      if @cop.update(cop_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to cops_path }
        format.json { render :show, status: :ok, location: @cop }
      else
        format.html { render :edit }
        format.json { render json: @cop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cops/1
  # DELETE /cops/1.json
  def destroy
    @cop.destroy
    flash[:notice] = I18n.t("notices.delete_success")
    respond_to do |format|
      format.html { redirect_to cops_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cop
      @cop = Cop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cop_params
      params.require(:cop).permit(:name, :description, :admin_id, :user_ids => [], :resource_ids => [])
    end
  end
  