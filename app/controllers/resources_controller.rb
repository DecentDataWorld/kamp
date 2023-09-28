class ResourcesController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show, :preview, :not_found, :download, :log_event]
  load_and_authorize_resource :only => [:edit, :update, :destroy], :find_by => :url
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :preview, :download, :rate_resource]
  layout "preview", only: [:preview]
  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash]


  # GET /resources
  # GET /resources.json
  def index

    redirect_to new_search_path

  end

  def not_found

  end

# GET /resources/1
# GET /resources/1.json
  def show
    check_resource_access

    log_view

    # check if user should be able to provide feedback
    if !@current_user.nil?
      if @resource.positive_users.include?(current_user.id.to_s) || @resource.negative_users.include?(current_user.id.to_s)
        @show_feedback = false
      else
        @show_feedback = true
      end
    else
      # unauthenticated user so look in their cookies to see if they can provide feedback
      feedback = feedback_array
      if feedback.include?(@resource.id.to_s)
        @show_feedback = false
      else
        @show_feedback = true
      end
    end

    if @resource.resource_type.downcase == "csv"
=begin
      require 'csv'
      quote_chars = %w(" | ~ ^ & *)

      @csv_table = CSV.new(open(@resource.attachment.url), :headers => true, quote_char: quote_chars.shift).read

      @csv_map = false

      latitude_values = ["latitude","lat"]
      latitude_found = false
      longitude_values = ["longitude","lon","long"]
      longitude_found = false

      @csv_table[0].each do |header|
        if !header[0].nil? and latitude_values.select { |a| a == header[0].downcase }.length > 0
          latitude_found = true
        end

        if !header[0].nil? and longitude_values.select { |a| a == header[0].downcase }.length > 0
          longitude_found = true
        end

      end

      if latitude_found and longitude_found
        @csv_map = true
      end
=end

    elsif @resource.resource_type == "geojson" || @resource.resource_type == "GeoJSON"
      @geo_text = File.read(@resource.attachment.path)

      @geo_text = 'var resourcegeotext = ' + @geo_text.to_s

    end


    @related_resources = @resource.find_related_tags.limit(5)

  end

# GET /resources/new
  def new
    @resource = Resource.new
    @resource.author = current_user
    @collections = Collection.where("organization_id in (?)", current_user.organizations.map(&:id)).order("title")
    @full_tags_list = ActsAsTaggableOn::Tag.all

    # logger.debug "Full Tag List: #{@full_tags_list.inspect}"

    if !params[:collection_id].nil?
      @collection = Collection.find_by_url(params[:collection_id])
      @resource.collection = @collection
    end

    @resource.license_id = 6


    return authenticate_current_user_role_for_adding_resources


  end

# GET /resources/1/edit
  def edit
    @collections = Collection.where("organization_id in (?)", current_user.organizations.map(&:id)).order("title")
    @full_tags_list = ActsAsTaggableOn::Tag.all

    return authenticate_current_user_role_for_editing_resource
  end

# POST /resources
# POST /resources.json
  def create
    @full_tags_list = ActsAsTaggableOn::Tag.all
    @resource = Resource.new(resource_params)
    @resource.tag_list = params[:resource][:tags]

    handle_collection_radios

    @resource.handle_file_type

    respond_to do |format|
      if @resource.save
        #ModeratorMailer.notify_submitter_of_moderation(@resource, current_user).deliver
        #ModeratorMailer.notify_admins_of_new_submission(@resource, current_user).deliver
        format.html {
          if params[:commit] == 'Save & Add Another'
            redirect_to new_resource_path, notice: 'Resource was successfully created.'
          else
            redirect_to @resource, notice: 'Resource was successfully created.'
          end
        }
        format.json { render action: 'show', status: :created, location: @resource }
      else
        flash[:error] = "Could not add resource"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /resources/1
# PATCH/PUT /resources/1.json
  def update
    @full_tags_list = ActsAsTaggableOn::Tag.all
    respond_to do |format|
      @resource.tag_list = params[:resource][:tags]
      logger.debug(@resource.tag_list + ' are the tags')
      if @resource.update(resource_params)

        handle_collection_radios

        @resource.handle_file_type

        @resource.save
        format.html {
          if !params[:destination].nil?
            redirect_to params[:destination], notice: 'Resource was successfully updated.'
          else
            redirect_to @resource, notice: 'Resource was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html {
          @collections = Collection.where("organization_id in (?)", current_user.organizations.map(&:id)).order("title")
          render action: 'edit', status: :unprocessable_entity }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /resources/1
# DELETE /resources/1.json
  def destroy
    @resource.destroy
    respond_to do |format|
      flash[:notice] = I18n.t('notices.delete_success')
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end


 def preview

   @page_title = "Preview Resource"

   #log_view
   puts "************************** 1 "
   if @resource.resource_type == "csv" || @resource.resource_type == "CSV"
     require 'csv'
     quote_chars = %w(" | ~ ^ & *)

     puts "************************** 2 "

     @csv_table = CSV.open(@resource.attachment.path, :headers => true, quote_char: quote_chars.shift).read

     @csv_map = false

     latitude_values = ["latitude","lat"]
     latitude_found = false
     longitude_values = ["longitude","lon","long"]
     longitude_found = false

     puts "************************** 3 "

     @csv_table[0].each do |header|
       if !header[0].nil? and latitude_values.select { |a| a == header[0].downcase }.length > 0
         latitude_found = true
         puts "************************** 4 "
       end

       if !header[0].nil? and longitude_values.select { |a| a == header[0].downcase }.length > 0
         longitude_found = true
         puts "************************** 5 "
       end

     end

     if latitude_found and longitude_found
       @csv_map = true

       puts "************************** 6 "
     end

   elsif @resource.resource_type == "geojson" || @resource.resource_type == "GeoJSON"
     @geo_text = File.read(@resource.attachment.path)

     puts "************************** 7 - geojson "

     @geo_text = 'var resourcegeotext = ' + @geo_text.to_s

   end

   render :layout => 'preview'
 end

  def download

    check_resource_access

    if @resource.attachment.exists?
      # need this check because can create resource with only source url and no attachment
      redirect_to @resource.attachment.expiring_url(10)
    else
      if @resource.source_url_valid?
        redirect_to @resource.source
      end
    end

    #send_file @resource.attachment.path, :type => @resource.attachment_content_type

  end

  def rate_resource

    if is_number?(params[:positive] )&& is_number?(params[:negative])

      # increment counts
      if @resource.positive.nil?
        @resource.positive = params[:positive]
      else
        @resource.positive = @resource.positive + params[:positive].to_i
      end
      if @resource.negative.nil?
        @resource.negative = params[:negative]
      else
        @resource.negative = @resource.negative + params[:negative].to_i
      end

      if !@current_user.nil?
        # this is an authenticated user, add their ID to the resource as having provided feedback
        if !@resource.positive_users.include?(@current_user.id.to_s) && !@resource.negative_users.include?(@current_user.id.to_s)
          # current user is not in the list so add them to the appropriate array
          if params[:positive].to_i > 0
            puts 'adding to positive'
            new_positive = @resource.positive_users + [@current_user.id]
            @resource.positive_users = new_positive
          elsif params[:negative].to_i > 0
            puts 'adding to negative'
            new_negative = @resource.negative_users + [@current_user.id]
            @resource.negative_users = new_negative
          end
        else
          puts 'already in list'
        end
      else
        puts 'user is not logged in'
      end

      puts @resource.inspect

      @resource.save!

      # add id of this cookie to the feedback cookie list
      feedback = feedback_array
      if feedback.include?(@resource.id.to_s)
        puts 'do nothing'
      else
        feedback.push(@resource.id)
        save_feedback_cookie(feedback)
      end

    end

    redirect_to @resource, notice: "Your feedback has been recorded"

  end

  def log_event

    if params.has_key?('event')
      survey_log = SurveyLog.new(event: params[:event])

      if params.has_key?('model')
        survey_log.model_type = params[:model]
      end
      if params.has_key?('model_id')
        survey_log.model_id = params[:model_id]
      end

      if !current_user.nil?
        survey_log.user_id = current_user.id
      end

      survey_log.save
    end


  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_resource
    @resource = Resource.find_by_url(params[:id])

    if @resource.nil?
      redirect_to resources_not_found_path, message: "That resource was not found"
    else
      impressionist(@resource)
    end
  end

  def authenticate_current_user_role_for_adding_resources
    if (cannot? :add, @resource or !current_user.has_approved_org) and cannot? :moderate, @resource
      redirect_to resources_path, alert: 'You cannot add resources without an approved organization'
    end
  end

  def authenticate_current_user_role_for_editing_resource
    if !@resource.can_edit(current_user) and cannot? :moderate, @resource
      redirect_to @resource, alert: 'You cannot edit this resource'
    end
  end

  def check_resource_access
    # unauthenticated users cannot view private or unnaproved resources
    if @current_user.nil? and (@resource.private || !@resource.approved?)
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users cannot view private resources that arent in their organization unless they are moderators or are the user that uploaded it
    elsif !@current_user.nil? and @resource.private and @current_user.has_org(@resource.organization).count == 0 and !can? :approve, @resource
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users cannot view resources that are not approved yet unless they are moderators
    elsif !@current_user.nil? and !@resource.approved and !can? :approve, @resource and !@current_user == @resource.author
      redirect_to root_path, alert: 'You do not have access to this private resource.'

      # authenticated users that are not mail chimp users should not be able to access newletter only resources
    elsif @resource.newsletter_only and (@current_user.nil? or @current_user.mail_chimp_user == false)
      redirect_to root_path, alert: 'You do not have access to this resource.'
    end

  end

  def save_feedback_cookie(feedback)
    cookies[:feedback] = (feedback.class == Array) ? feedback.join(",") : ''
  end

  def feedback_array
    cookies[:feedback] ? cookies[:feedback].split(",") : []
  end

  def handle_collection_radios
    if !params[:collection_title].blank?
      # a new collection is being created
      new_collection = Collection.new(:title => params[:collection_title])
      new_collection.organization_id = params[:resource][:organization_id]
      new_collection.author = current_user
      new_collection.save
      @resourcing = Resourcing.new
      @resourcing.resourceable_type = "Collection"
      @resourcing.resourceable_id = new_collection.id
    elsif !params[:resource][:collection_id].blank?
      @resourcing = Resourcing.new
      @resourcing.resourceable_type = "Collection"
      @resourcing.resourceable_id = params[:resource][:collection_id]
    end
  end

  def log_view
    Resource.increment_counter(:view_count, @resource.id)
  end

    def is_number? string
      true if Float(string) rescue false
    end


# Never trust parameters from the scary internet, only allow the white list through.
  def resource_params
    params.require(:resource).permit(:activity_id, :url, :name, :description, :format, :collection_id, :status, :resource_type, :attachment, :author_id, :license_id, :organization_id, :private, :tag_list, :source, :language, :issue_date, :corporate_authorship, :newsletter_only, :cop_id, :cop_private )
  end
end
