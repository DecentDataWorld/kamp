class UserMailer < ActionMailer::Base

  default from: "help@jordankmportal.com"

  def registration_email(user)
    admins = User.with_role :admin
    @recipients = admins.pluck(:email)
    mail(:to => @recipients, :subject => "[KaMP] #{user.name} (#{user.email}) just registered for the Portal")
  end

  def invitation_email(email_address, verify)
    @email_address = email_address
    @verify = verify
    @link = root_url + 'sign_up?email_address='+email_address+'&email_token='+verify
    mail(:to => @email_address, :subject => "Invitation to register for the Jordan Knowledge Management Portal [KaMP]")
  end

  def denial_email(user)
    mail(to: user.email, subject: "[KaMP] Your application was denied")
  end

end
