class ModeratorController < ApplicationController
  before_action :authorize_moderator

  def index
    @page_title = "Moderate Pending Submissions"

    handle_pending_resources
  end

  def approve
    if !params[:submission_id].nil? && !params[:submission_type].nil?
      if params[:submission_type] == "resource"
        @submission = Resource.find(params[:submission_id])
      elsif params[:submission_type] == "collection"
        @submission = Collection.find(params[:submission_id])
      end
      @submission.approved = true
      @submission.save

      # send email notification
      ModeratorMailer.notify_submitter_of_approval(@submission, @submission.author).deliver

      return redirect_to moderate_submissions_path, notice: 'Submission was approved'
    else
      return redirect_to moderate_submissions_path, alert: 'The link you followed does not appear to be valid'
    end
  end

  def denial
    add_crumb 'Moderate Sumissions', moderate_submissions_path
    @page_title = "Deny Submission"
    if !params[:submission_id].nil? && !params[:submission_type].nil?
      if params[:submission_type] == "resource"
        @submission = Resource.find(params[:submission_id])
      elsif params[:submission_type] == "collection"
        @submission = Collection.find(params[:submission_id])
      end

    else
      return redirect_to moderate_submissions_path, alert: 'The link you followed does not appear to be valid'
    end
  end

  def deny

    if !params[:submission_id].nil? && !params[:submission_type].nil?
      if params[:submission_type] == "resource"
        @submission = Resource.find(params[:submission_id])
        @reason = DenialReason.find(params[:resource][:reason])
      elsif params[:submission_type] == "collection"
        @submission = Collection.find(params[:submission_id])
        @reason = DenialReason.find(params[:collection][:reason])
      end

      # send email notification
      ModeratorMailer.notify_submitter_of_denial(@submission, @submission.author, @reason).deliver

      @submission.destroy

      return redirect_to moderate_submissions_path, notice: 'Submission was denied'
    else
      return redirect_to moderate_submissions_path, alert: 'The link you followed does not appear to be valid'
    end
  end

  def denied
    @page_title = "Denied Submissions"


    @sunspot_search = Sunspot.search Resource, Collection do
      with(:approved, false)

      # activate pagination after 10 results
      paginate :page => params[:page], :per_page => 10
    end
    @pending_submissions = @sunspot_search.results
  end

  def users
    @users = User.with_role :moderator

  end

  private

  def authorize_moderator
    if !can? :approve, Resource and !can? :approve, Collection
      return redirect_to root_path, alert: 'You do not have the ability to moderate submissions'
    end
  end

  def handle_pending_resources

    @pending_submissions = Resource.where(:approved => false).paginate(page: params[:page], per_page: 10)

  end

end
