class ModeratorMailer < ActionMailer::Base

  default from: "help@jordankmportal.com"

  def notify_submitter_of_approval(submission, user)
    @submission = submission
    @user = user

    mail(to: user.email, subject: '[KaMP] Your resource has been approved ')
  end

  def notify_submitter_of_denial(submission, user, reason)
    @submission = submission
    @user = user
    @reason = reason

    mail(to: user.email, subject: '[KaMP] Your resource has been denied ')
  end

  def notify_submitter_of_moderation(submission, user)
    @submission = submission
    @user = user

    mail(to: user.email, subject: '[KaMP] Acknowledgment of newly uploaded resource ')
  end

  def notify_admins_of_new_submission(submission, user)
    @submission = submission
    @user = user
    @moderators = User.with_role(:admin)
    @recipients = @moderators.pluck(:email)

    mail(to: @recipients, subject: '[KaMP] A new submission was made and is pending approval ')
  end

  def notify_subscribers(submission)
    @submission = submission
    @organization_name = submission.organization.name
    @recipients = User.where(id: UserSubscription.where(subscribed_to: 'organization', subscribed_to_id: @submission.organization_id).pluck(:user_id)).pluck(:email)
    if @recipients.length > 0
      mail(to: @recipients, subject: "[KaMP] A new resource has been uploaded to #{@organization_name}")
    end
  end

end
