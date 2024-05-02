class DenialReasonsController < ApplicationController
  before_action :set_denial_reason, only: [:show, :edit, :update, :destroy]
  before_action :authorize_moderator

  respond_to :html

  def index
    add_crumb 'Moderate Submissions', moderate_submissions_path
    @page_title = "Denial Reasons"
    @denial_reasons = DenialReason.all
    respond_with(@denial_reasons)
  end

  def show
    respond_with(@denial_reason)
  end

  def new
    add_crumb 'Moderate Submissions', moderate_submissions_path
    add_crumb 'Denial Reasons', denial_reasons_path
    @page_title = "New Denial Reason"
    @denial_reason = DenialReason.new
    respond_with(@denial_reason)
  end

  def edit
    add_crumb 'Moderate Submissions', moderate_submissions_path
    add_crumb 'Denial Reasons', denial_reasons_path
    @page_title = "Editing Denial Reason"
  end

  def create
    @denial_reason = DenialReason.new(denial_reason_params)
    if @denial_reason.save
      flash[:notice] = "Reason created successfully"
      redirect_to denial_reasons_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @denial_reason.update(denial_reason_params)
      redirect_to denial_reasons_path, notice: 'Reason edited successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @denial_reason.destroy
      flash[:notice] = I18n.t("notices.delete_success")
      respond_with(@denial_reason)
    else
      flash[:notice] = "Could not delete Reason."
      redirect_back(fallback_location: denial_reasons_path)
    end
  end

  private
    def set_denial_reason
      @denial_reason = DenialReason.find(params[:id])
    end

    def denial_reason_params
      params.require(:denial_reason).permit(:reason)
    end

  def authorize_moderator
    if !can? :approve, Resource and !can? :approve, Collection
      return redirect_to root_path, alert: 'You do not have the ability to moderate submissions'
    end
  end
end
