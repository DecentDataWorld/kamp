class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_current_user
  before_action :get_blank_search

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  # Lograge method for adding extra info to Logging
  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
    payload[:user_id] = if current_user.present?
      current_user.try(:id)
    else
      :guest
    end
  end

  #used to prevent routing errors from raising fatal exceptions in production
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found if Rails.env.production?

  def record_not_found
    not_found
  end

  def not_found(message = nil)
    raise ActionController::RoutingError.new(message)
  end

  private

  def get_current_user
    if user_signed_in? and @current_user.nil?
      @current_user = current_user
    end
  end

  def get_blank_search
    if @search.nil?
      @search = Search.new
    end
  end

end
