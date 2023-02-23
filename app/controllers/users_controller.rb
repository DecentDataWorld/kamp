class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :request_invite, :send_invite]
  before_filter :authorize_user_admin, only: [:index, :get_users]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    add_crumb 'Administration', admin_index_path
    @page_title = "Manage Users"

    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @admin_role = User.preload(:users_organizations, :organizations, :roles, :users_roles).order(created_at: :desc).with_any_role(:admin, :moderator)
    @member_role = User.preload(:users_organizations, :organizations, :roles, :users_roles).order(created_at: :desc).without_role(:admin)
  end

  def show
    @user = User.find(params[:id])
    @page_title = @user.name + " Profile"
    @resources = @user.resources.where("private = false and approved = true and newsletter_only = false").page(params[:resources_page]).per_page(10).order("updated_at desc")
    @collections = @user.collections_authored.where("private = false and approved = true and newsletter_only = false").page(params[:collections_page]).per_page(10).order("updated_at desc")
    @organizations = @user.organizations.page(params[:organizations_page]).per_page(10).order("updated_at desc")

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
      @resource_pending_results = Sunspot.search(Resource, Collection) do
        with(:author_id, @current_user_id)
        with(:approved, false)

        if current_user.nil? || current_user.mail_chimp_user == false
          puts "cannot see newsletter stuff"
          with(:newsletter_only, false)
        end

        order_by :updated_at, :desc
        paginate :page => params[:resources_page], :per_page => 10
      end
      @resources_pending = @resource_pending_results.results
    end
  end
  
  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
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
      get_org = Organization.find_by(:name => params[:organization].strip)
      if !get_org.nil?
        subscribed_to_id = get_org.id
        check_if_exists = UserSubscriptions.where("user_id = ? and subscribed_to = ? and subscribed_to_id = ?", @user.id, params[:subscribed_to].strip, subscribed_to_id)
        if check_if_exists.count == 0
          user_sub = UserSubscriptions.new(:user_id => params[:user_id], :subscribed_to_id => subscribed_to_id, :subscribed_to => 'organization')
          user_sub.save
        end
      else
        error_msg = "Organization not found"
      end

    end

    if error_msg == ""
      if params[:destination].nil?
        redirect_to @user, :notice => "Subscription Added."
      else
        redirect_to params[:destination], :notice => "Subscription Added."
      end
    else
      redirect_to @user, :alert => error_msg
    end


  end

  def remove_subscription

    @user = User.find(params[:id])

    if current_user != @user
      redirect_to users_path(@user), :alert => "You are not authorized to make changes to this user's subscriptions"
    end

    if !params[:subscribed_to_id].nil?
      subscription = UserSubscriptions.find_by(user_id: @user.id, subscribed_to: params[:subscribed_to], subscribed_to_id: params[:subscribed_to_id])
      subscription.delete
    end

    redirect_to @user, :notice => "Subscription Removed."

  end

  def export
    @page_title = "Export Users"
    @users = User.all
    render layout: false
  end

  def request_invite

  end

  def send_invite
    digest = OpenSSL::Digest.new('sha1')
    @email_address = params[:invitation_email]
    @verify = OpenSSL::HMAC.hexdigest(digest, ENV['EMAIL_HASH_KEY'], @email_address)
    puts @verify
    UserMailer.invitation_email(@email_address, @verify)
    redirect_to root_path, :notice => "An invitation to register has been sent to #{@verify}. Please check your email inbox."
  end

  private
  def authorize_user_admin
    unless can? :manage, User
      redirect_to access_denied_path, :alert => 'You do not have access to this section'
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
    params.require(:user).permit(:id, :role_ids, :invitation_email)
  end
end