class OrganizationsController < ApplicationController
  load_and_authorize_resource :only => [:edit, :update, :destroy], :find_by => :url
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :deactivate, :private_resources]
  before_action :authorized?, :except => [:index, :show, :not_found]

  # GET /organizations
  def index
    @organizations = Organization.where(deactivated_at: nil).where("organizations.name ILIKE ?", "%#{params[:search]}%").order(name: :asc).paginate(:page => params[:page], :per_page => 30)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    if !params[:collection_page].nil? && session[:collection_page] != params[:collection_page]
      @show_collections = true
    else
      @show_collections = false
    end

    session[:collection_page] = params[:collection_page] || nil

    @page_title = @organization.name

    @users = @organization.users.where(deactivated_at: nil).order(:name)
    params[:id] = @organization.id

    # decide if we have to hide private and pending resources from this user
    if !@organization.can_add_collections(current_user)
      hide_private = true
      @hide_pending = true
    else
      @hide_pending = false
    end

    if current_user.nil?
      @subscribed = false
      @logged_in = false
    else
      @logged_in = true
      check_subscription = UserSubscriptions.where("user_id = ? and subscribed_to = 'organization' and subscribed_to_id = ?", current_user.id, @organization.id)
      if check_subscription.count == 0
        @subscribed = false
      else
        @subscribed = true
      end
    end

    # if user is able to view pending user applications get any that aren't yet approved
    if (@organization.can_manage_users(current_user) or can? :manage, :all)
      puts 'Checking for pending applications'
      @pending_applications = OrganizationApplication.where("organization_id = ? and approved IS NULL", @organization.id)
    end

    # get all submissions for this organization
    resource_results = Resource.search_kmp(search_terms=params[:resource_query], tags="", org=@organization.id, language=nil, days_back=nil, only_approved=true, exclude_private=hide_private)
    @resource_count = resource_results[:count]
    @resources = Resource.where(id: resource_results[:ids]).order("updated_at desc").paginate(page: params[:page], per_page: 10)

    collection_results = Collection.search_kmp(search_terms=params[:resource_query], tags="", org=@organization.id, days_back=nil, only_approved=true, exclude_private=hide_private)
    @collection_count = collection_results[:count]
    @collections = Collection.where(id: collection_results[:ids]).order("updated_at desc").paginate(page: params[:collection_page], per_page: 10)

     # if current_user.nil? || current_user.mail_chimp_user == false
       # puts "cannot see newsletter stuff"
       # with(:newsletter_only, false)
     # end

    # get all private resources for this organization
    if (current_user && current_user.organizations.exists?(@organization.id)) or can? :manage, :all
      @private_resources = @organization.private_resources.paginate(:page => params[:page]).per_page(20)
    end

    # if user can view pending submissions, query for them
    if @hide_pending == false
      @resources_pending = Resource.where(:organization_id => @organization.id).where(:approved => false).order("updated_at desc")
      @collections_pending = Collection.where(:organization_id => @organization.id).where(:approved => false).order("updated_at desc")
    end

  end

  # GET /organizations/new
  def new
    @page_title = "Apply To Become A Partner Organization"
    @organization = Organization.new
    @organization.creator_id = current_user.id.to_s
  end

  # GET /organizations/1/edit
  def edit
    add_crumb("Edit " + @organization.name)
    @page_title = "Edit " + @organization.name

    if !@organization.can_edit_organization(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You do not have the ability to edit this organization'
    end
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        # add current user to this organization
        user_org = UsersOrganization.new
        user_org.role = "admin"
        user_org.organization = @organization
        user_org.user = current_user
        user_org.save
        # get the current user's email domain and store it with the organization
        @organization.domain = current_user.email.split("@").last
        @organization.save
        AdminMailer.notify_admins_of_new_organization(@organization).deliver
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organization }
      else
        format.html { render action: 'new', status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    if @organization.domain.blank?
      @organization.domain = @organization.users.first.email.split("@").last
    end

    if !@organization.can_edit_organization(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You do not have the ability to edit this organization'
    end

    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    if !@organization.admins and !@organization.admins.first.nil
      OrganizationMailer.deny_organization_application(@organization, @organization.admins.first.user).deliver
    end


    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_path }
      format.json { head :no_content }
    end
  end

  def deactivate
    authorize! :destroy, @organization, :message => 'Not authorized as an administrator.'
    if @organization.deactivate
      redirect_to organizations_path, :notice => "Organization deactivated."
    end
  end

  def process_application
    @get_application = OrganizationApplication.find(params[:id])

    if @get_application.nil?
      return redirect_to @get_application.organization, alert: 'Cannot find application'
    end

    if !@get_application.organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @get_application.organization, alert: 'You are not able to manage users of this organization'
    end



    if params[:result] == "approve"
      # add user to organization
      users_organization = UsersOrganization.new
      users_organization.organization_id = @get_application.organization_id
      users_organization.user_id = @get_application.user_id
      users_organization.role = "member"
      users_organization.save

      #update application to reflect approved status
      @get_application.approved = true
      @get_application.save

      # send email notification
      OrganizationMailer.approve_membership_to_user(@get_application.organization, @get_application.user).deliver
      return redirect_to organization_path(@get_application.organization_id), notice: 'User application processed'
    elsif params[:result] != "deny"
      return redirect_to @get_application.organization, alert: 'Invalid status for application'
    end

    @organization = @get_application.organization
  end

  def process_application_denial

    @get_application = OrganizationApplication.find(params[:organization_application][:id])

    if !@get_application.organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end

    @get_application.approved = false

    if !params[:organization_application][:comment].blank?
      @get_application.comment = params[:organization_application][:comment]
    end

    @get_application.save

    OrganizationMailer.deny_membership_to_user(@get_application.organization, @get_application.user, @get_application.comment).deliver

    return redirect_to organization_path(@get_application.organization_id), notice: 'User application denied'
  end

  def add_user
    @page_title = "Add User To Organization"
    @organization = Organization.find_by_url(params[:organization])
    @users_organization = UsersOrganization.new
    @users_organization.organization_id = @organization.id
    @inviteuser = User.new

    if !@organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end
  end

  def edit_user
    add_crumb("Modify Member Role")
    @page_title = "Modify Member Role"
    @users_organization = UsersOrganization.find_by :id => params[:userorg]
    @organization = @users_organization.organization

    if !@organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end
  end

  def process_new_user
    @users_organization = UsersOrganization.new(users_organization_params)

    @users_organization.organization_id = params[:organization_id]
    @users_organization.user_id = params[:user_id]
    @users_organization.role = params[:role]

    respond_to do |format|
      if @users_organization.save
        format.html { redirect_to @users_organization.organization, notice: 'Users organization was successfully created.' }
        format.json { render action: 'show', status: :created, location: @users_organization.organization }
      else
        format.html { render action: 'add_user' }
        format.json { render json: @users_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve_organization
    @organization = Organization.find_by_url(params[:organization])

    if cannot? :approve, @organization
      flash[:notice] = 'You do not have sufficient rights to perform that action.'
      return redirect_back(fallback_location: organizations_path)
    end

    @organization.approved = true
    if @organization.save
      AdminMailer.notify_organization_admins_of_org_approval(@organization).deliver
      flash[:notice] = 'Organization was successfully approved.'
      redirect_back(fallback_location: organizations_path)
    else
      flash[:error] = 'Could not approve organization.'
      redirect_back(fallback_location: organizations_path)
    end
  end

  def apply
    add_crumb("No Approved Organization")
    @page_title = "No Approved Organization"

    if !current_user.organizations.blank?
      @has_pending = true
    else
      @has_pending = false
    end
  end

  def not_found

  end

  # check to see if the current user is part of the organization
  def check_organization_privileges!
    if !@organization.users.exists?(current_user)
      redirect_to organization_add_user_path, notice: 'You do not have sufficient rights to perform that action.'
    end
  end

  def private_resources
    @page_title = @organization.name

    @resources = @organization.private_resources.paginate(:page => params[:page]).per_page(20)

  end

  def invite_user
    @user = User.invite!(:email => params[:user][:email], :name => params[:user][:name])
    redirect_to organizations_process_user_path(params[:organization_id]), notice: 'Invitation was successfully sent.'
  end


  private

  # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find_by_url(params[:id])
      if @organization.nil?
        @organization = Organization.find_by_id(params[:id])
      end
      if @organization.nil?
        flash[:error] = "Could not find organization"
        redirect_back(fallback_location: organizations_path)
      end
    end

    def authorized?
      return true if can? :manage, :all

      @organization = Organization.find_by_url(params[:id])
      if @organization.nil?
        @organization = Organization.find_by_id(params[:id])
      end
      if @organization.nil?
        @organization = Organization.find_by_url(params[:organization])
      end

      unless (!@organization.nil? && @organization.can_manage_users(current_user))
        flash[:error] = "You are not authorized to view that page."
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:url, :name, :description, :status, :logo, :users, :domain, :organization_type_id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def users_organization_params
      params.permit(:organization_id, :user_id, :role, :organization_type_id)
    end
end
