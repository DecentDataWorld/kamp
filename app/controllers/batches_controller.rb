class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized?
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  # GET /batches
  # GET /batches.json
  def index
    @batches = Batch.all.order('updated_at desc')
  end

  # GET /batches/1
  # GET /batches/1.json
  def show
    @full_tags_list = ActsAsTaggableOn::Tag.all
    @collections = current_user.collections_authored
  end

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches
  # POST /batches.json
  def create
    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to @batch, notice: 'Batch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @batch }
      else
        format.html { render action: 'new' }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batches/1
  # PATCH/PUT /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to @batch, notice: 'Batch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1
  # DELETE /batches/1.json
  def destroy
    @batch.destroy
    respond_to do |format|
      format.html { redirect_to batches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_params
      params.require(:batch).permit(:name, :uploader_id)
    end

  def authorized?
    unless can? :manage, :all
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end
end
