class UserMailer < ActionMailer::Base
<<<<<<< HEAD
  default from: "kampadmin@jordanmela.com"
=======
  default from: "kamp-support@jordanmela.com"
>>>>>>> 1f35fded2ceafe2a9d43a00d54b300b2ed6df5e1

  def registration_email(user)
    admins = User.with_role :admin
    @recipients = admins.pluck(:email)
    # should go to support@msidevcloud.com
    mail(:to => @recipients, :subject => "[KaMP] #{user.name} (#{user.email}) just registered for the Portal")
  end

end
