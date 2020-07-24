class AdminMailer < ActionMailer::Base
  default from: "kamp-support@jordanmela.com"

  def notify_admins_of_new_organization(organization)
    @organization = organization

    admins = User.with_role :admin
    @recipients = admins.pluck(:email)
    # should go to support@msidevcloud.com
    # changed to go to support@jordanmela.com
    mail(to: @recipients, subject: '[KaMP] New Organization Pending Approval: ')

  end

  def notify_organization_admins_of_org_approval(organization)
    @organization = organization
    @to_string = ''
    @organization.admins.each do |user_org|
      if @to_string.length > 1
        @to_string = @to_string + ','
      end
      @to_string = @to_string + user_org.user.email
    end
    mail(to: @to_string, subject: '[KaMP] Your Organization has been approved')

  end

end
