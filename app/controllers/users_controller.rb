require 'csv'
class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :request_invite, :send_invite, :unsubscribe]
  before_action :authorize_user_admin, only: [:index, :get_users]
  after_action :assign_cop, only: [:create]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'

    respond_to do |format|
      format.html {
        @users = User.where(deactivated_at: nil).where("users.name ILIKE ?", "%#{params[:search]}%").includes(:users_organizations, :organizations, :roles, :organization_applications).order(name: :asc).paginate(:page => params[:page], :per_page => 30)

        if params[:organization_id]
          @users = @users.filter{|u| params[:organization_id].length > 0 ? u.users_organizations.pluck(:organization_id).include?(params[:organization_id].to_i) : u.users_organizations.pluck(:organization_id)}
        end

        if params[:role_id]
          @users = @users.filter{|u| params[:role_id].length > 0 ? u.roles.pluck(:role_id).include?(params[:role_id].to_i) : u.roles.pluck(:role_id)}
        end

        if params[:usage_id]
          if params[:usage_id] == 'ninety'
            @users = @users.where('users.created_at > ? ', Time.now - 90.days)
          elsif params[:usage_id] == 'year'
            @users = @users.where('last_sign_in_at < ?', Time.now - 1.year)
          end
        end
      }
      format.csv {
        @users = User.where(deactivated_at: nil).includes(:users_organizations, :organizations, :roles, :organization_applications).order(name: :asc)
        send_data users_to_csv(@users)
      }
    end
  end

  def show
    @user = User.find(params[:id])
    @resources = @user.resources.where("private = false and approved = true and newsletter_only = false").page(params[:resources_page]).per_page(10).order("updated_at desc")
    @collections = @user.collections_authored.where("private = false and approved = true and newsletter_only = false").page(params[:collections_page]).per_page(10).order("updated_at desc")
    @organizations = @user.organizations.page(params[:organizations_page]).per_page(10).order("updated_at desc")
    @cops = @user.cops.page(params[:cops_page]).per_page(10).order('updated_at desc')
    @subscriptions = @user.subscriptions.where(subscribed_to: 'organization')
    @page_title = @user.name

    # if user is current user can view pending submissions, query for them
    @current_user = current_user

    if @current_user == @user
      @user_subscription = UserSubscriptions.new
      @user_subscription.user_id = @current_user.id
      @tags = ActsAsTaggableOn::Tag.all.order(:name)
      @user_tags = UserSubscriptions.where("user_id = ? and subscribed_to = 'tag'", @user.id).pluck(:subscribed_to_id)
      @tag_subs = ActsAsTaggableOn::Tag.where('id in (?)', @user_tags)
      @orgs = Organization.all.order("name")
      @user_org_subs = UserSubscriptions.where("user_id = ? and subscribed_to = 'organization'", @user.id).pluck(:subscribed_to_id)
      @org_subs = Organization.where('id in (?)', @user_org_subs)
    end

    @current_user_id = @user.id
    if current_user == @user or can? :approve, Resource or can? :approve, Collection
      @resources_pending = @user.resources.where("approved = false").order("updated_at desc")
    end
  end

  def edit
    @user = User.find(params[:id])
    @page_title = "Edit " + @user.name
  end

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = I18n.t("notices.update_success")
        format.html { redirect_to users_path }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:error] = "Could not update user"
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_role
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    unless @user == current_user
      if @user.update_attribute(:role_ids, params[:role_ids])
        redirect_back(fallback_location: users_path)
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    unless @user == current_user
      puts 'going to delete' + @user.id.to_s
      @user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def deny
    @user = User.find(params[:id])
    UserMailer.denial_email(@user).deliver
    deactivate("User denied. An email has been sent to this user providing likely reasons for denial.")
  end

  def deactivate(msg="")
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    unless @user == current_user
      @user.deactivate
      flash[:notice] = msg.blank? ? "User deactivated." : msg
      redirect_back(fallback_location: users_path)
    else
      flash[:notice] = "Can't deactivate yourself."
      redirect_back(fallback_location: users_path)
    end
  end

  def unlock_user
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    @user.expired_at = nil?
    @user.save
    redirect_to users_path, :notice => "User unlocked."
  end

  def get_users
    if params.has_key? :admin
      return_users = User.with_role(:admin)
    else
      return_users = User.all
    end
    render json: { data: return_users }
  end

  def save_subscriptions
    @user = User.find(params[:id])

    if current_user != @user
      redirect_to users_path(@user), :alert => "You are not authorized to make changes to this user's subscriptions"
    end

    error_msg = ""

    if params[:subscribed_to] == 'tag'
      sub_to = ActsAsTaggableOn::Tag.find_by(name: params[:tag].strip)
      if !sub_to.nil?
        subscribed_to_id = sub_to.id
        check_if_exists = UserSubscriptions.where("user_id = ? and subscribed_to = ? and subscribed_to_id = ?", @user.id, params[:subscribed_to], subscribed_to_id)
        if !sub_to.nil? and check_if_exists.count == 0
          user_sub = UserSubscriptions.new(:user_id => params[:user_id], :subscribed_to_id => subscribed_to_id, :subscribed_to => 'tag')
          user_sub.save
        end
      else
        error_msg = "Tag not found"
      end

    elsif params[:subscribed_to] == 'organization'
      respond_to do |format|
        organization = Organization.find_by_id(params[:subscribed_to_id])
        subscription = UserSubscription.new(user_id: params[:id], subscribed_to_id: params[:subscribed_to_id], subscribed_to: 'organization')

        if organization && subscription.save
          flash[:notice] = "Subscription added."
          format.html { redirect_back(fallback_location: params[:destination]) }
          format.json { head :no_content }
        else
          flash[:notice] = "Could not add subscription."
          format.html { redirect_back(fallback_location: params[:destination]) }
          format.json { render json: user_sub.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def remove_subscription
    @user = User.find(params[:id])

    if current_user != @user
      redirect_to users_path(@user), :alert => "You are not authorized to make changes to this user's subscriptions"
    end

    if !params[:subscribed_to_id].nil?
      subscription = UserSubscriptions.find_by(user_id: @user.id, subscribed_to: params[:subscribed_to], subscribed_to_id: params[:subscribed_to_id])
      if subscription.delete
        flash[:notice] = "Successfully unsubscribed."
      else
        flash[:notice] = "Could not unsubscribe."
      end
    end

    redirect_back(fallback_location: @user)
  end

  def remove_membership
    uo = UsersOrganization.find_by(user_id: params[:user_id], organization_id: params[:organization_id])
    uo.destroy! if uo
    redirect_back(fallback_location: users_path)
  end

  def remove_cop_membership
    user = User.find_by_id(params[:user_id])
    cop = user.cops.find_by_id(params[:cop_id])
    if cop && user.cops.delete(cop)
      flash[:notice] = "Successfully removed user from COP."
    else
      flash[:error] = "Could not remove user from COP."
    end
    redirect_back(fallback_location: users_path)
  end

  def export
    @page_title = "Export Users"
    @users = User.all
    render layout: false
  end

  def request_invite

  end

  def send_invite
    if User.all.pluck(:email).include?(params[:invitation_email])
      flash[:notice] = "An account already exists with this email address. Please enter a different email address, or click 'Sign In' to log in with this existing account."
      redirect_back(fallback_location: request_invite_path)
      return
    end

    digest = OpenSSL::Digest.new('sha1')
    @email_address = params[:invitation_email]

    if User.do_not_email.pluck(:email).include?(@email_address) || User.unregistered_do_not_email.include?(@email_address)
      flash[:error] = "This user has requested not to receive emails from Jordan KaMP and cannot be invited to register."
      redirect_back(fallback_location: users_path)
    else
      @verify = OpenSSL::HMAC.hexdigest(digest, ENV['EMAIL_HASH_KEY'], @email_address)
      UserMailer.invitation_email(@email_address, @verify).deliver
      redirect_to root_path, :notice => "An invitation to register has been sent to #{@email_address}. Please check your email inbox."
    end
  end

  def unsubscribe
    if params.has_key?(:verify) && params.has_key?(:email)
      digest = OpenSSL::Digest.new('sha1')
      hmac = OpenSSL::HMAC.hexdigest(digest, ENV['EMAIL_HASH_KEY'], params[:email])

      if params[:verify] == hmac
        User.unsubscribe(params[:email])
        render json: {:message => 'You have successfully unsubscribed from Jordan KaMP emails.'}, status: :ok
      else
        render json: {:message => 'Failed to unsubscribe you from Jordan KaMP emails. Please contact the website administrator at help@jordankmportal.com'}, status: :unprocessable_entity
      end
    else
      render json: {:message => t('errors.error')}, status: :unprocessable_entity
    end
  end

  private
  def assign_cop
    @user = User.find(params[:id])
    @user.assign_cop
  end

  def authorize_user_admin
    unless can? :manage, User
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end

  def users_to_csv(users)
    CSV.generate do |csv|
      csv << ['ID', 'Name','Email','Role','Organizations','Last Sign In','Created']
      users.each do |u|
        csv_array = []
        csv_array << u.id
        csv_array << u.name
        csv_array << u.email
        csv_array << u.roles.pluck(:name).join(', ').titleize
        !u.organizations.nil? ? csv_array << u.organizations.pluck(:name).join(', ') : csv_array << ''
        csv_array << u.last_sign_in_at
        csv_array << u.created_at
        csv << csv_array
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(id: params[:id])
  end

  def handle_record_not_found
    redirect_to access_denied_path, :alert => 'You have followed an outdated link/URL'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:id, :role_ids, :invitation_email, :search, :organization_id)
  end
end
