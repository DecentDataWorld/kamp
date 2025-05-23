class OrganizationMailer < ActionMailer::Base

  default from: "help@jordankmportal.com"


  def notify_organization_admins_of_new_application(organization, user)
    @organization = organization
    @user = user

    @to_string = ''
    if @organization.admins.length > 0
      @organization.admins.each do |user_org|
        if @to_string.length > 1
          @to_string = @to_string + ','
        end
        @to_string = @to_string + user_org.user.email
      end
      mail(to: @to_string, subject: '[KaMP] Someone has applied to join your organization: ')
    else
      site_admins = User.with_role(:admin).pluck(:email)
      mail(to: site_admins.join(','), subject: '[KaMP] Someone has applied to join an organization: ')
    end
  end

  def deny_organization_application(organization, user)
    @organization = organization
    @user = user

    # should go to @user.email
    mail(to: @user.email, subject: '[KaMP] Your Organization has been denied')
  end

  def deny_membership_to_user(organization, user, message)
    @organization = organization
    @user = user
    @message = message

    # should go to @user.email
    mail(to: @user.email, subject: '[KaMP] Membership request has been denied')
  end

  def approve_membership_to_user(organization, user)
    @organization = organization
    @user = user
    @message = message

    # should go to @user.email
    mail(to: @user.email, subject: '[KaMP] Membership request has been approved')
  end

end
