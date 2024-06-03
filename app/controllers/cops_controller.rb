class CopsController < ApplicationController
  before_action :set_cop, only: [:edit, :update, :destroy, :show, :show_cop, :show_email_info, :show_event_email_info]
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
    hide_cop_private = !current_user.cops.include?(@cop)
    # get all submissions for this cop
    resource_results = Resource.search_kmp(search_terms=params[:resource_query], tags="", org=nil, cop=@cop.id, language=nil, days_back=nil, only_approved=true, exclude_private=true, exclude_cop_private=hide_cop_private)
    @resource_count = resource_results[:count]
    @resources = Resource.where(id: resource_results[:ids]).order("updated_at desc").paginate(page: params[:page], per_page: 10)
    @new_event_request_email_body = Event.request_email_body(@current_user)
    @new_announcement_request_email_body = Announcement.request_email_body(@current_user)

    # collection_results = Collection.search_kmp(search_terms=params[:resource_query], tags="", cop=@cop.id, days_back=nil, only_approved=true, exclude_private=hide_private)
    # @collection_count = collection_results[:count]
    # @collections = Collection.where(id: collection_results[:ids]).order("updated_at desc").paginate(page: params[:collection_page], per_page: 10)

    # get all private resources for this cop
    if (current_user && current_user.cops.exists?(@cop.id)) or can? :manage, :all
      @private_resources = @cop.private_resources.paginate(:page => params[:page]).per_page(20)
    end
  end

  # GET /cops/1
  def show_cop
    hide_cop_private = !current_user || !current_user.cops.include?(@cop)
    # get all submissions for this cop
    resource_results = Resource.search_kmp(search_terms=params[:resource_query], tags="", org=nil, cop=@cop.id, language=nil, days_back=nil, only_approved=true, exclude_private=true, exclude_cop_private=hide_cop_private)
    @resource_count = resource_results[:count]
    @resources = Resource.where(id: resource_results[:ids]).order("updated_at desc").paginate(page: params[:page], per_page: 10)
    @new_event_request_email_body = Event.request_email_body(@current_user)
    @new_announcement_request_email_body = Announcement.request_email_body(@current_user)

    # collection_results = Collection.search_kmp(search_terms=params[:resource_query], tags="", cop=@cop.id, days_back=nil, only_approved=true, exclude_private=hide_private)
    # @collection_count = collection_results[:count]
    # @collections = Collection.where(id: collection_results[:ids]).order("updated_at desc").paginate(page: params[:collection_page], per_page: 10)

    # get all private resources for this cop
    if (current_user && current_user.cops.exists?(@cop.id)) or can? :manage, :all
      @private_resources = @cop.private_resources.paginate(:page => params[:page]).per_page(20)
    end
  end

  #GET /cop_email_info/1
  def show_email_info
  end

  #GET /cop_event_email_info/1
  def show_event_email_info
    @event = Event.find(params[:event])
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
  