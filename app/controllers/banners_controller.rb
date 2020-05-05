class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions

  respond_to :html

  def index
    @banners = Banner.all
    respond_with(@banners)
  end

  def show
    respond_with(@banner)
  end

  def new
    @banner = Banner.new
    respond_with(@banner)
  end

  def edit
  end

  def create
    @banner = Banner.new(banner_params)
    @banner.save
    redirect_to banners_path, message: 'Banner Created Successfully'
      #respond_with(@banner)
  end

  def update
    @banner.update(banner_params)
    redirect_to banners_path, message: 'Banner Created Successfully'
    # respond_with(@banner)
  end

  def destroy
    @banner.destroy
    respond_with(@banner)
  end

  private
    def check_permissions
      if cannot? :manage, Banner
        redirect_to access_denied_path, alert: 'You do not have permission to access this section of the site'
      end
    end

    def set_banner
      @banner = Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:visible, :heading, :intro_text, :col1_heading, :col1_body, :col2_heading, :col2_body, :footnote, :banner_type)
    end
end
