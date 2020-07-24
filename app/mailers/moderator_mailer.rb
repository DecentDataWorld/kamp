class ModeratorMailer < ActionMailer::Base
<<<<<<< HEAD
  default from: "kampadmin@jordanmela.com"
=======
  default from: "kamp-support@jordanmela.com"
>>>>>>> 1f35fded2ceafe2a9d43a00d54b300b2ed6df5e1
# changed to go to support@jordanmela.com
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

    @moderators = User.with_role(:moderator, :admin)
    @recipients = @moderators.pluck(:email)


    mail(to: @recipients, subject: '[KaMP] A new submission was made and is pending approval ')

  end

end
