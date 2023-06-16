class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.order(:name)

    respond_to do |format|
      format.html
      format.json { render json: @events.order(:name), status: :ok }
    end
  end


  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.tag_list = params[:event][:tags]
    @event.user_id = 1 if !params[:event][:user_id]

    respond_to do |format|
      if @event.save
        flash[:notice] = I18n.t("notices.create_success")
        format.html { redirect_to events_path }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.tag_list = params[:event][:tags]
    respond_to do |format|
      if @event.update(event_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to events_path }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    flash[:notice] = I18n.t("notices.delete_success")
    respond_to do |format|
      format.html { redirect_to events_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :short_description, :long_description, :date, :location, :virtual, :url, :public, :featured, :user_id, :cop_id, :tag_list)
    end
  end
  