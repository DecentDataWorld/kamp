class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy, :show_event]
  before_action :authorized?, except: [:public_events, :show_event]

  #GET /events
  def public_events
    @events = Event.active.is_public.order(:start_date => :asc)
    @featured_events = @events.featured
    @new_event_request_email_body = Event.request_email_body(@current_user)
  end

  #GET /events/1
  def show_event
  end

  # GET /admin/events
  # GET /admin/events.json
  def index
    if can? :manage, :all
      @events = Event.order(:name)
    else
      cop_ids = Cop.where(:admin_id => current_user.id).pluck(:id)
      @events = Event.where(:cop_id => cop_ids).order(:name)
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @events.order(:name), status: :ok }
    end
  end


  # GET /admin/events/new
  def new
    @event = Event.new
  end

  # GET /admin/events/1/edit
  def edit
  end

  # POST /admin/events
  # POST /admin/events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        flash[:notice] = I18n.t("notices.create_success")
        format.html { redirect_to events_path }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/events/1
  # PATCH/PUT /admin/events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to events_path }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/events/1
  # DELETE /admin/events/1.json
  def destroy
    respond_to do |format|
      if @event.destroy
        flash[:notice] = I18n.t("notices.delete_success")
        format.html { redirect_to events_path }
        format.json { head :no_content }
      else
        flash[:notice] = I18n.t("notices.delete_failure")
        format.html { redirect_back(fallback_location: events_path) }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def authorized?
      unless (can? :manage, :all) || current_user.cop_admin?
        flash[:error] = "You are not authorized to view that page."
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :short_description, :long_description, :start_date, :location, :is_virtual, :url, :is_private, :is_featured, :user_id, :cop_id)
    end
  end
  