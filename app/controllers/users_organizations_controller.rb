class UsersOrganizationsController < ApplicationController
  before_action :set_users_organization, only: [:show, :edit, :update, :destroy]

  # GET /users_organizations
  # GET /users_organizations.json
  def index
    if  !can? :manage, :all
      return redirect_to root_url, notice: 'You are not able to manage users of this organization'
    end
    @users_organizations = UsersOrganization.all
  end

  # GET /users_organizations/1
  # GET /users_organizations/1.json
  def show
    if  !can? :manage, :all
      return redirect_to root_url, notice: 'You are not able to manage users of this organization'
    end
  end

  # GET /users_organizations/new
  def new
    if  !can? :manage, :all
      return redirect_to root_url, notice: 'You are not able to manage users of this organization'
    end
    @users_organization = UsersOrganization.new
  end

  # GET /users_organizations/1/edit
  def edit
    if  !can? :manage, :all
      return redirect_to root_url, notice: 'You are not able to manage users of this organization'
    end
  end

  # POST /users_organizations
  # POST /users_organizations.json
  def create
    @users_organization = UsersOrganization.new(users_organization_params)

      @organization = Organization.find_by :id => params[:users_organization][:organization_id]
    puts 'org_id =' + params[:users_organization].to_s

    if !@organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end
    respond_to do |format|
      if @users_organization.save
        format.html { redirect_to @users_organization.organization, notice: 'Member was successfully added.' }
        format.json { render action: 'show', status: :created, location: @users_organization }
      else
        format.html { render 'organizations/add_user' }
        format.json { render json: @users_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users_organizations/1
  # PATCH/PUT /users_organizations/1.json
  def update
    if !@users_organization.organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end
    respond_to do |format|
      if @users_organization.update(users_organization_params)
        format.html { redirect_to @users_organization.organization, notice: 'Member role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @users_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users_organizations/1
  # DELETE /users_organizations/1.json
  def destroy
    if !@users_organization.organization.can_manage_users(current_user) and !can? :manage, :all
      return redirect_to @organization, notice: 'You are not able to manage users of this organization'
    end
    return_org_id = @users_organization.organization_id
    @users_organization.destroy
    respond_to do |format|
      format.html { redirect_to organization_path(return_org_id) }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_users_organization
    @users_organization = UsersOrganization.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def users_organization_params
    params.require(:users_organization).permit(:organization_id, :user_id, :role)
  end
end
