class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :authorized?

  # GET /categories
  # GET /categories.json
  def index
    add_crumb 'Administration', admin_index_path if user_signed_in? and can? :manage, :all
    @page_title = "Manage Categories"

    @full_tags_list = ActsAsTaggableOn::Tag.all

    @categories = Category.all.order("name ASC")

    build_unused_tag_list

  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @page_title = "Tag Category"
  end

  # GET /categories/new
  def new
    add_crumb 'Administration', admin_index_path
    add_crumb 'Tag Categories', categories_path
    @page_title = "New Category"

    @category = Category.new

    if cannot? :add, @category
      redirect_to categories_path, alert: 'You cannot add categories to the portal'
    end

    @full_tags_list = ActsAsTaggableOn::Tag.all

    @categories = Category.all.order("name ASC")

    build_unused_tag_list
  end

  # GET /categories/1/edit
  def edit
    add_crumb 'Administration', admin_index_path
    add_crumb 'Tag Categories', categories_path
    @page_title = "Edit Category"

    if cannot? :edit, @category
      redirect_to categories_path, alert: 'You are not authorized to edit this category'
    end

    @full_tags_list = ActsAsTaggableOn::Tag.all

    @categories = Category.all.order("name ASC")

    build_unused_tag_list
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    @category.tag_list = params[:category][:tags]

    if cannot? :add, @category
      redirect_to categories_path, alert: 'You cannot add categories to the portal'
    end


    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update

    if cannot? :edit, @category
      redirect_to categories_path, alert: 'You are not authorized to edit this category'
    end

    respond_to do |format|
      if @category.update(category_params)
        @category.tag_list = params[:category][:tags]
        @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy

    if cannot? :destroy, @category
      redirect_to categories_path, alert: 'You are not authorized to remove this category'
    end

    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private

  def authorized?
    unless can? :manage, :all
      flash[:error] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end

  def build_unused_tag_list

      @tags_left = []

      @full_tags_list.each do |tag|
        @tags_left = @tags_left.push(tag)
      end

      @categories.each do |category|
        category.tags.each do |tag|
          @tags_left.delete(tag)
        end
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find_by_url(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :description, :tag_list)
    end
end
