class HealthcheckController < ApplicationController
  before_action :set_cache_headers

  def check_db
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      status = :ok
      message = "Database connection healthy"
    rescue => e
      status = :service_unavailable
      message = "Database connection error: #{e.message}"
      Rails.logger.error("Healthcheck failed: #{e.message}")
    end

    render json: { status: message }, status: status
  end

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end
end
