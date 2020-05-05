class DataController < ApplicationController

  def csv
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: CSVDatatable.new(view_context) }
    end
  end

end
