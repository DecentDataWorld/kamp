class DenialReasonsController < ApplicationController
  before_action :set_denial_reason, only: [:show, :edit, :update, :destroy]
  before_action :authorize_moderator

  respond_to :html

  def index
    add_crumb 'Moderate Sumissions', moderate_submissions_path
    @page_title = "Denial Reasons"
    @denial_reasons = DenialReason.all
    respond_with(@denial_reasons)
  end

  def show
    respond_with(@denial_reason)
  end

  def new
    add_crumb 'Moderate Sumissions', moderate_submissions_path
    add_crumb 'Denial Reasons', denial_reasons_path
    @page_title = "New Denial Reason"
    @denial_reason = DenialReason.new
    respond_with(@denial_reason)
  end

  def edit
    add_crumb 'Moderate Sumissions', moderate_submissions_path
    add_crumb 'Denial Reasons', denial_reasons_path
    @page_title = "Editing Denial Reason"
  end

  def create
    @denial_reason = DenialReason.new(denial_reason_params)
    @denial_reason.save

    redirect_to denial_reasons_path, notice: 'Reason created successfully'
  end

  def update
    @denial_reason.update(denial_reason_params)

    redirect_to denial_reasons_path, notice: 'Reason edited successfully'
  end

  def destroy
    @denial_reason.destroy
    respond_with(@denial_reason)
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
