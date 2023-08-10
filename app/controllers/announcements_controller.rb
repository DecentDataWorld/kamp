class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:edit, :update, :destroy, :show_announcement]

  #GET /announcements
  def public_announcements
    @announcements = Announcement.active.is_public.order(:expiration_date => :desc)
    @featured_announcements = @announcements.featured
  end

  #GET /announcements/1
  def show_announcement
  end

  # GET /admin/announcements
  # GET /admin/announcements.json
  def index
    @announcements = Announcement.order(:name)
    
    respond_to do |format|
      format.html
      format.json { render json: @announcements.order(:name), status: :ok }
    end
  end

  # GET /admin/announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /admin/announcements/1/edit
  def edit
  end

  # POST /admin/announcements
  # POST /admin/announcements.json
  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user_id = current_user.id

    respond_to do |format|
      if @announcement.save
        flash[:notice] = I18n.t("notices.create_success")
        format.html { redirect_to announcements_path }
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/announcements/1
  # PATCH/PUT /admin/announcements/1.json
  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to announcements_path  }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/announcements/1
  # DELETE /admin/announcements/1.json
  def destroy
    
    respond_to do |format|
      @announcement.destroy
      flash[:notice] = I18n.t("notices.delete_success")
      format.html { redirect_to announcements_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def announcement_params
      params.require(:announcement).permit(:name, :short_description, :long_description, :expiration_date, :is_private, :is_featured, :user_id, :cop_id)
    end
end
