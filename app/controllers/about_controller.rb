class AboutController < ApplicationController

  def index
    @page_title = "About This Portal"
  end

  def no_approved_org
    add_crumb "Cannot Add Resources"
    @page_title = "Cannot Add Resources"
  end

  def access_denied
    add_crumb "Access Limited"
    @page_title = "Access Limited"
  end

  def types
    add_crumb "About", about_path
    add_crumb "Resource Types"
    @page_title = "Resource Types"
  end

  def new_users

  end

  def disclaimer
    @page_title = "Disclaimer"
  end

end
