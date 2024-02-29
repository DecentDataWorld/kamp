class RegistrationsController < Devise::RegistrationsController
  before_action :update_sanitized_params, if: :devise_controller?

  def create
    if ((params[:user][:organization_entered].nil? || params[:user][:organization_entered].length < 1) && (params[:organization_applications].nil? || params[:organization_applications].length < 1)) || (!params[:user][:organization_entered].nil? && !params[:user][:organization_entered].blank? && params[:user][:organization_type].blank?)
      if (params[:user][:organization_entered].nil? || params[:user][:organization_entered].length < 1) && (params[:organization_applications].nil? || params[:organization_applications].length < 1)
        flash[:error] = I18n.t('errors.organization_or_application_required')
      elsif (!params[:user][:organization_entered].nil? && !params[:user][:organization_entered].blank? && params[:user][:organization_type].blank?)
        flash[:error] = I18n.t('errors.organization_type_required')
      end
      return redirect_back(fallback_location: root_path)
    end

    super
    if resource.save
      # notify admins of new user
      @user = resource
      UserMailer.registration_email(@user)

      # turned off on 10/3/2017
      # auto join use to org based on email domain
      user_domain = resource.email.split("@").last
      # matching_orgs = Organization.where("domain = ?", user_domain)
      #
      # matching_org_domains = []
      # matching_orgs.each do |organization|
      #   new_relationship = UsersOrganization.new
      #   new_relationship.user = resource
      #   new_relationship.organization = organization
      #   new_relationship.role = 'member'
      #   new_relationship.save
      #   unless matching_org_domains.include?(organization.domain)
      #     matching_org_domains << organization.domain
      #   end
      #
      # end

      # if user has chosen an existing organization and has not already been added, add organization application record
      if !params[:organization_applications].nil? and !params[:organization_applications].blank?
        #unless matching_org_domains.include?(user_domain)
        org_entered_id = params[:organization_applications]
        org_being_applied_to = Organization.find(org_entered_id)
        new_application = OrganizationApplication.new(:user_id => @user.id, :organization_id => params[:organization_applications])
        new_application.save
        OrganizationMailer.notify_organization_admins_of_new_application(org_being_applied_to, @user).deliver
        #end
      elsif !params[:user][:organization_entered].nil? && !params[:user][:organization_entered].blank? && !params[:user][:organization_type].blank?
        # if user has entered a new org name and type, create organization and apply
        new_organization = Organization.new(:name => params[:user][:organization_entered], :domain => user_domain, :organization_type_id => params[:user][:organization_type])
        new_organization.save!

        # add current user to this organization as the admin
        user_org = UsersOrganization.new
        user_org.role = "admin"
        user_org.organization = new_organization
        user_org.user = @user
        user_org.save!

        # create organization application for approval
        new_application = OrganizationApplication.new(:user_id => @user.id, :organization_id => new_organization.id)
        new_application.save!

        #notify admins of new organization request
        AdminMailer.notify_admins_of_new_organization(new_organization).deliver
      end
    end
  end

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:name, :email, :password, :password_confirmation, :avatar, :humanizer_answer, :humanizer_question_id, :organization_id, :organization_entered, :organization_type, :email_token, :email_address)}
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :title, :google, :twitter, :facebook, :linkedin)}
  end

  private

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      set_minimum_password_length
      respond_with resource
    end
  end

end
