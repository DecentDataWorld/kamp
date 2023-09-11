class CollectionsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :only => [:edit, :update, :destroy], :find_by => :url
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :rate_collection]
  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash]

  # GET /collections
  # GET /collections.json
  def index
    redirect_to new_search_path
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    #@page_title = 'View Collection'
    log_view

    # unauthenticated users cannot view private or unnaproved resources
    if @current_user.nil? and (@collection.private || !@collection.approved?)
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users cannot view private resources that arent in their organization unless they are moderators
    elsif !@current_user.nil? and @collection.private and @current_user.has_org(@collection.organization).count == 0 and !can? :approve, @collection
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users cannot view resources that are not approved yet unless they are moderators or are the user that uploaded it
    elsif !@current_user.nil? and !@collection.approved and !can? :approve, @collection and !@current_user == @collection.author
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users that are not mail chimp users should not be able to access newletter only resources
    elsif @collection.newsletter_only and (@current_user.nil? or @current_user.mail_chimp_user == false)
      redirect_to root_path, alert: 'You do not have access to this resource.'
    end

    # check if user should be able to provide feedback
    if !@current_user.nil?
      if @collection.positive_users.include?(current_user.id.to_s) || @collection.negative_users.include?(current_user.id.to_s)
        @show_feedback = false
      else
        @show_feedback = true
      end
    else
      # unauthenticated user so look in their cookies to see if they can provide feedback
      feedback = feedback_array
      if feedback.include?(@collection.id.to_s)
        @show_feedback = false
      else
        @show_feedback = true
      end
    end

    @related_collections = @collection.find_related_tags.limit(5)
    @current_user = current_user

  end

  # GET /collections/new
  def new
    add_crumb("New Collection")
    @page_title = 'New Collection'

    # create new collection and populate
    @collection = Collection.new
    @collection.author_id = current_user.id
    @collection.maintainer_id = current_user.id

    if !params[:organization_id].nil?
      @organization = Organization.find_by :id => params[:organization_id]
      @collection.organization = @organization
    else
      @collection.organization = current_user.organizations.first
    end

    # do some checking to make sure current_user can add collections to
    return authenticate_current_user_role_for_collections
    return authenticate_current_user_for_collection

  end

  # GET /collections/1/edit
  def edit
    add_crumb("Edit Collection")
    @page_title = 'Edit Collection'

    if (cannot? :edit, @collection or !@collection.can_edit(current_user)) and cannot? :moderate, @collection
      redirect_to @collection, alert: 'You cannot edit this collection'
    end

  end

  # POST /collections
  # POST /collections.json
  def create
    add_crumb("New Collection")
    @page_title = 'New Collection'
    @collection = Collection.new(collection_params)
    @collection.organization = Organization.find_by :id => params[:collection][:organization_id]
    @collection.tag_list = params[:collection][:tags]

    # do some authentication to make sure user can edit this collection
    authenticate_current_user_role_for_collections

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @collection }
      else
        flash[:error] = "Could not add collection"
        format.html { render action: 'new' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update

    # do some authentication to make sure user can edit this collection
    authenticate_current_user_role_for_collections

    respond_to do |format|
      if @collection.update(collection_params)

        @collection.tag_list = params[:collection][:tags]
        @collection.save

        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy

    # do some authentication to make sure user can delete this collection
    authenticate_current_user_role_for_collections

    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :no_content }
    end
  end

  def not_found

  end

  def rate_collection

    if is_number?(params[:positive] )&& is_number?(params[:negative])

      # increment counts
      if @collection.positive.nil?
        @collection.positive = params[:positive]
      else
        @collection.positive = @collection.positive + params[:positive].to_i
      end
      if @collection.negative.nil?
        @collection.negative = params[:negative]
      else
        @collection.negative = @collection.negative + params[:negative].to_i
      end

      if !@current_user.nil?
        # this is an authenticated user, add their ID to the resource as having provided feedback
        if !@collection.positive_users.include?(@current_user.id.to_s) && !@collection.negative_users.include?(@current_user.id.to_s)
          # current user is not in the list so add them to the appropriate array
          if params[:positive].to_i > 0
            puts 'adding to positive'
            new_positive = @collection.positive_users + [@current_user.id]
            @collection.positive_users = new_positive
          elsif params[:negative].to_i > 0
            puts 'adding to negative'
            new_negative = @collection.negative_users + [@current_user.id]
            @collection.negative_users = new_negative
          end
        else
          puts 'already in list'
        end
      else
        puts 'user is not logged in'
      end

      @collection.save!

      # add id of this cookie to the feedback cookie list
      feedback = feedback_array
      if feedback.include?(@collection.id.to_s)
        puts 'do nothing'
      else
        feedback.push(@collection.id)
        save_feedback_cookie(feedback)
      end

    end

    redirect_to @collection, notice: "Your feedback has been recorded"

  end



  private

  def authenticate_current_user_role_for_collections
    if (cannot? :add, @collection or !@collection.can_add_resources(current_user)) and cannot? :moderate, @collection
      redirect_to @collection, alert: 'You cannot edit this collection'
    end
  end

  def authenticate_current_user_for_collection
    if (current_user.organizations.nil? or !current_user.has_approved_org) and cannot? :moderate, @collection
      redirect_to no_approved_orgs_path, alert: 'No approved organizations'
    elsif (@collection.organization.nil? or !@collection.organization.users.exists?(current_user)) and cannot? :moderate, @collection
      redirect_to organizations_path(@collection.organization), alert: 'You are not approved to add collections to this organization'
    end
  end

  def save_feedback_cookie(feedback)
    cookies[:collections_feedback] = (feedback.class == Array) ? feedback.join(",") : ''
  end

  def feedback_array
    cookies[:collections_feedback] ? cookies[:collections_feedback].split(",") : []
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find_by_url(params[:id])
    if @collection.nil?
      redirect_to collections_not_found_path, message: "That collection was not found"
    else
      impressionist(@collection)
    end
  end

  def log_view
    Collection.increment_counter(:view_count, @collection.id)
  end

  def is_number? string
    true if Float(string) rescue false
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(:activity_id, :url, :title, :description, :status, :author_id, :maintainer_id, :type_id, :organization_id, :license_id, :notes, :tag_list, :image, :private, :newsletter_only)
  end
end
