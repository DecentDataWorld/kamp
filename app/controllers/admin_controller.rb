class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized?

  def index
    @page_title = "Administration"
    no_role_ids = User.no_role_ids
    @show_orgs = params[:org_page].to_i > params[:page].to_i
    @users_needing_role = User.where(id: no_role_ids).where(deactivated_at: nil).page(params[:page]).per_page(5).order("created_at desc")
    @organizations = Organization.where(approved: [false, nil]).page(params[:org_page]).per_page(5).order("created_at asc")

    handle_pending_resources

    @licenses = License.all
    @types = Type.all
    @inviteuser = User.new
  end

  def invite_user
    @user = User.invite!(:email => params[:user][:email], :name => params[:user][:name])
    redirect_to admin_index_path, notice: 'Invitation was successfully sent.'
  end

  def manage_tags
    add_crumb 'Administration', admin_index_path
    @page_title = "Manage Tags"
    @full_tags_list = ActsAsTaggableOn::Tag.all.order(:name)

  end

  def edit_tag
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Tags', manage_tags_path
    @page_title = "Edit Tag"
    @tag = ActsAsTaggableOn::Tag.find_by :name => params[:tag]
  end

  def new_tag
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Tags', manage_tags_path
    @page_title = "Add Tag"
    @tag = ActsAsTaggableOn::Tag.new
  end

  def delete_tag
    add_crumb 'Administration', admin_index_path
    add_crumb 'Manage Tags', manage_tags_path
    @page_title = "Delete Tag"
    @tag = ActsAsTaggableOn::Tag.find_by :id => params[:tag]
    @tag.delete

    flash[:message] = "Tag was removed"
    redirect_to manage_tags_path
  end

  def update_tag
    if !params[:acts_as_taggable_on_tag][:id].blank?
      @tag = ActsAsTaggableOn::Tag.find(params[:acts_as_taggable_on_tag][:id])
      @tag.name = params[:acts_as_taggable_on_tag][:name]
      flash[:message] = "Tag was updated"
    else
      @tag = ActsAsTaggableOn::Tag.new(:name => params[:acts_as_taggable_on_tag][:name])
      flash[:message] = "Tag was added"
    end

    @tag.save
    redirect_to manage_tags_path
  end

  def orgs
    add_crumb 'Administration', admin_index_path
    @page_title = "Manage Organizations"
    @organizations = Organization.order("created_at desc")
  end

  def edit_org
    add_crumb 'Administration', admin_index_path
    add_crumb("Edit " + @organization.name)
    @page_title = "Edit " + @organization.name

    if !@organization.can_edit_organization(current_user)
      return redirect_to @organization, notice: 'You do not have the ability to edit this organization'
    end
  end

  def private_resources
    @page_title = "All Private Resources"

    @resources = Resource.where("private = ?", true).paginate(:page => params[:page])

  end

  def upload_files
    add_crumb 'Administration', admin_index_path
    @page_title = "Upload Resources as a group"

    @batches = Batch.all.order("created_at asc")
  end

  def fix_resource_collections_menu
    @count_resources = Resource.where("collection_id IS NOT NULL").count
  end

  def fix_resource_collections

    @resources = Resource.where("collection_id IS NOT NULL").order("created_at desc")

    @counter = 0
    @resources.each do |resource|
      translate_relationship_for_collections(resource)
    end


  end

  def contest

    @page_title = "Contest Report - Most Accessed Resources"

    @most_accessed = Resource.where("impressions_count > 0").order("impressions_count desc").paginate(:page => params[:page])
  end

  def contest_report
    @page_title="Contest Report - Downloadable Report"
    @resource = Resource.new

    params.has_key?(:start_date) ? @start_date = params[:start_date] : @start_date = nil
    params.has_key?(:end_date) ? @end_date = params[:end_date] : @end_date = nil

    @impressions = Resource.where("impressions_count > 0")
    if !@start_date.nil?
      @impressions = @impressions.where("created_at >= ?", @start_date)
    end
    if !@end_date.nil?
      @impressions = @impressions.where("created_at <= ?", @end_date)
    end

    respond_to do |format|
      format.html {
        @impressions = @impressions.order("impressions_count desc").paginate(:page => params[:page])
      }
      format.csv {
        @impressions = @impressions.order("impressions_count desc")
        send_data access_report_to_csv(@impressions)
      }
    end
  end

  def resource_ratings
    @page_title = "Resource Ratings"

    @resources = Resource.find_by_sql ['SELECT id, name, positive, negative,
        ((positive + 1.9208) / (positive + negative) -
        1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
        (positive + negative)) / (1 + 3.8416 / (positive + negative))
        AS ci_lower_bound
      FROM resources
      WHERE positive + negative > 0
      ORDER BY ci_lower_bound DESC']

    @collections = Collection.find_by_sql ['SELECT id, title, positive, negative,
        ((positive + 1.9208) / (positive + negative) -
        1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
        (positive + negative)) / (1 + 3.8416 / (positive + negative))
        AS ci_lower_bound
      FROM collections
      WHERE positive + negative > 0
      ORDER BY ci_lower_bound DESC']

  end

  def collection_ratings

  end

  def survey_report

    @page_title = "Survey Report"

    params.has_key?(:start_date) ? @start_date = params[:start_date] : @start_date = Date.today - 30
    params.has_key?(:end_date) ? @end_date = params[:end_date] : @end_date = Date.today

    @logs = SurveyLog.where("date_trunc('day', created_at) >= ?::date and date_trunc('day', created_at) <= ?::date", @start_date, @end_date)

    respond_to do |format|
      format.html {

      }
      format.csv {
        send_data survey_report_to_csv(@logs)
      }
    end

  end

  def process_uploaded_files

    require 'securerandom'
    require 'zip/zipfilesystem'

    # generate a random string to mix into the filename
    random_string_var = SecureRandom.hex(8)

    # get name of original file
    name =  params[:file_upload].original_filename
    # store temporary file location into a variable
    temp_file_data = params[:file_upload].tempfile

    # create a unique name for the file
    new_name = File.basename(name, '.*').to_s() + random_string_var.to_s() + File.extname(name)

    # create the full file path with the new filename
    path = File.join(ENV['FILES_TEMP_PATH'], new_name)
    # read the contents of the pdf into a file
    zip_file = File.read(temp_file_data)

    # write the file to the active folder
    File.open(path, "wb") { |f| f.write(zip_file) }

    @current_batch = Batch.new
    @current_batch.name = DateTime.now.strftime('%m%d%Y%H%M%S') + "_" + current_user.id.to_s + "_" + current_user.name.underscore
    @current_batch.uploader_id = current_user.id
    @current_batch.save!

    @upload_counter = 0
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |resources|
      resources.each do |file|
        next unless file.file?
        fpath = File.join(ENV['FILES_TEMP_PATH'], file.to_s)
        FileUtils.mkdir_p(File.dirname(fpath))
        if !fpath.include? "._"
          #the block is for handling an existing file. returning true will overwrite the files.
          resources.extract(file, fpath){ true }

          # Create a new resource with this file

          resource = Resource.new(:attachment => File.new(fpath, 'r'))

          # Give the resource a name and temporary description
          resource.name = "Imported Resource"
          resource.description = "Imported Resource"
          resource.organization = current_user.organizations.first

          resource.author_id = current_user.id
          resource.handle_file_type

          # assign it to a group batch
          resource.batch = @current_batch

          # mark it private
          resource.private = true

          # set it's organization to Jordan MESP since they are the only ones who can access this feature
          resource.organization_id = 1

          resource.save!

          @upload_counter = @upload_counter + 1
          FileUtils.rm(fpath)
        end


      end
    end

    # validate that this is a zip file

    # loop through the zip file and extract it to temporary directory

    # loop through contents of directory and upload each file as a new resource

    # delete file after you are done with it

    # delete folder after you are done with it

  end

  private

  def authorized?
    unless can? :dashboard, current_user
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end

  def handle_pending_resources

    if can? :approve, Resource or can? :approve, Collection
      @pending_submissions = Resource.where(:approved => false)
    end

  end

  def translate_relationship_for_collections(resource)

    if !resource.collection_id.nil?
      new_link = Resourcing.new(:resource_id=>resource.id, resourceable_type: "Collection", resourceable_id: resource.collection_id)
      new_link.save
      resource.collection_id = nil
      resource.save
      @counter = @counter + 1
    end

  end

  def survey_report_to_csv(results)
    CSV.generate do |csv|
      csv << ['Event','User ID','User Email','Page','Item ID','Item Name','Occurred']
      results.each do |log|
        !log.user_id.nil? ? log_user = User.find(log.user_id) : log_user = nil

        if log.model_type != 'Search Result' and !log.model_id.nil?
          log.model_type == 'Resource' ? item = Resource.find(log.model_id) : item = Collection.find(log.model_id)
        end
        csv_array = []
        csv_array << log.event
        csv_array << log.user_id
        log_user.nil? ? csv_array << '' : csv_array << log_user.email
        csv_array << log.model_type
        item.nil? ? csv_array << '' : csv_array << item.id
        item.nil? ? csv_array << '' : csv_array << item.name
        csv_array << log.created_at
        csv << csv_array
      end
    end
  end

  def access_report_to_csv(results)

    CSV.generate do |csv|
      csv << ["Resource Name","Uploaded By","Date of Upload","Total Views","Uniquely Accessed","Viewed By","Total Downloads","Downloaded By"]
      results.each do |resource|
        if !resource.nil?
          shown = resource.impressions.where("action_name = 'show'")
          if !@start_date.nil?
            shown = shown.where("created_at >= ?", @start_date)
          end
          if !@end_date.nil?
            shown = shown.where("created_at <= ?", @end_date)
          end
          downloaded = resource.impressions.where("action_name = 'download'")
          if !@start_date.nil?
            downloaded = downloaded.where("created_at >= ?", @start_date)
          end
          if !@end_date.nil?
            downloaded = downloaded.where("created_at <= ?", @end_date)
          end
          csv_array = []
          csv_array << resource.name
          resource.organization.nil? ? csv_array << '' : csv_array << resource.organization.name
          csv_array << resource.created_at
          csv_array << resource.impressionist_count
          csv_array << shown.count
          shown_users = ""
          shown.select("DISTINCT user_id").each do |impression|
            if !impression.user_id.nil? && User.exists?(impression.user_id)
              user = User.find(impression.user_id)
              if shown_users.split(",").count > 0
                user_name = ", "+user.name
              else
                user_name = user.name
              end
              shown_users << user_name
            end
          end
          csv_array << shown_users
          csv_array << downloaded.count
          download_users = ""
          downloaded.select("DISTINCT user_id").each do |impression|
            if !impression.user_id.nil? && User.exists?(impression.user_id)
              download_user = User.find(impression.user_id)
              if download_users.split(",").count > 0
                downloader_name = ", "+download_user.name
              else
                downloader_name = download_user.name
              end
              download_users << downloader_name
            end
          end
          csv_array << download_users
          csv << csv_array
        end
      end
    end
  end


end
