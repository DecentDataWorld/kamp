class ResourcingsController < ApplicationController
  before_action :set_resourcing, only: [:new, :show, :edit, :update, :destroy]

  respond_to :html

  def index

    if  !can? :manage, :all
      return redirect_to root_url, notice: 'You are not able to access this section'
    end
    @resourcings = Resourcing.all
    respond_with(@resourcings)
  end

  def new
    @resourcing = Resourcing.new
    @coll = Collection.find_by url: params["#{@klass.name.underscore}_id"]
    @resourcing.resourceable_id = @coll.id
    @resourcing.resourceable_type = @klass
    @resourcing.resource = Resource.new
    @resourcing.resource.author = current_user
    @klass_name = @klass.name
    @page_title = 'Add Resources to ' + @klass.name
    respond_with(@resourcing)
  end

  def create
    @resourcing = Resourcing.new(resourcing_params)

    if !params[:resourcing][:resource_id].blank?
      # adding an existing resource into this collection
      @resourcing.resource_id = params[:resourcing][:resource_id]
      check_exists = Resourcing.where('resource_id = ? and resourceable_type = ? and resourceable_id = ?', @resourcing.resource_id, @resourcing.resourceable_type, @resourcing.resourceable_id)
      if check_exists.count == 0
        @resourcing.save
        redirect_to @resourcing.resourceable, notice: 'Resource Added'
      else
        redirect_to @resourcing.resourceable, alert: 'Resource Already exists here'
      end
    else
      # adding a new resource so handle the tag list
      @resourcing.resource.tag_list = params[:resourcing][:resource_attributes][:tags]
      # save and return to resourceable if valid
      if @resourcing.save
        redirect_to @resourcing.resourceable, notice: "Resource Added"
      else
        @coll = Collection.find(params[:resourcing][:resourceable_id])
        @resourcing.resourceable_id = params[:resourcing][:resourceable_id]
        @resourcing.resourceable_type = params[:resourcing][:resourceable_type]
        @resourcing.resource = Resource.new
        @resourcing.resource.author = current_user
        @klass_name = params[:resourcing][:resourceable_type]
        @page_title = "Add Resources to " + params[:resourcing][:resourceable_type]
        @resourcing.errors[:base] << "Choose an existing resource or add a new one"
        render action: 'new'
      end
    end

  end

  def remove_resourcing
    has_error = false
    if !params.has_key?('resource_id') or !params.has_key?('collection_id')
      has_error = true
    else
      @resource = Resource.find_by(id: params[:resource_id])
      @collection = Collection.find_by(id: params[:collection_id])

      if @resource.nil? or @collection.nil?
        has_error = true
      else
        if (can? :moderate, @collection) or (@collection.can_edit(@current_user)) or (@collection.can_add_resources(@current_user))
          resourcing = Resourcing.find_by(resource_id: @resource.id, resourceable_type: "Collection", resourceable_id: @collection.id)

          if resourcing.nil?
            has_error = true
          else
            resourcing.destroy
          end

        else
          has_error = true
        end

      end


    end

    if has_error
      redirect_to error_page_path, alert: 'An error occurred removing that resource'
    else
      redirect_to @collection, message: 'Resource was removed from this collection'
    end



  end

  # DELETE /resourcings/1
  # DELETE /resourcings/1.json
  def destroy
    @resourcing.destroy
    respond_to do |format|
      format.html { redirect_to resourcings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_resourcing
    @klass = [Collection].detect { |c| params["#{c.name.underscore}_id"]}
    @resourceable = @klass.find_by url: params["#{@klass.name.underscore}_id"]
    #@resourcing = Resourcing.find(params[:id])
  end

  def resourcing_params
    params.require(:resourcing).permit(:resource_id, :resourceable_id, :resourceable_type, :resources,
                                       :resource_attributes => [:activity_id, :name, :description, :format, :collection_id, :resource_type, :status, :attachment, :author_id, :organization_id, :private, :source, :language, :issue_date, :view_count, :corporate_authorship, :cop_id, :cop_private])
  end

end
