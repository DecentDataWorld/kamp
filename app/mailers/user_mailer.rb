class UserMailer < ActionMailer::Base

  default from: "help@jordankmportal.com"

  def registration_email(user)
    admins = User.with_role :admin
    @recipients = admins.pluck(:email)
    # should go to support@msidevcloud.com
    mail(:to => @recipients, :subject => "[KaMP] #{user.name} (#{user.email}) just registered for the Portal")
  end

  def invitation_email(email_address, verify)
    @email_address = email_address
    @verify = verify
    # should go to support@msidevcloud.com
    mail(:to => @email_address, :subject => "Invitation to register for the Jordan Knowledge Management Portal [KaMP]")
  end

end
