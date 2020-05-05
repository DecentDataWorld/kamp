class UserMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']

  def registration_email(user)
    admins = User.with_role :admin
    @recipients = admins.pluck(:email)
    # should go to support@msidevcloud.com
    mail(:to => @recipients, :subject => "[KaMP] #{user.name} (#{user.email}) just registered for the Portal")
  end

end
