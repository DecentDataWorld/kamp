class SurveyController < ApplicationController
  def index

    if params.has_key?(:sg_sessionid)
      survey_log = SurveyLog.new(event: 'Survey Completed')
        if session.has_key?(:last_search_id)
        @return_to_search = session[:last_search_id]
      end

      if params.has_key?(:return_resource)
        survey_log.model_type = 'Resource'
        resource = Resource.find_by(url: params[:return_resource])
        survey_log.model_id  = resource.id
        @return_to_resource = params[:return_resource]
      elsif params.has_key?(:return_collection)
        survey_log.model_type = 'Collection'
        collection = Collection.find_by(url: params[:return_collection])
        survey_log.model_id = collection.id
        @return_to_collection = params[:return_collection]
      end

      if !current_user.nil?
        survey_log.user_id = current_user.id
      end

      survey_log.save

    end

  end

  def done
  end
end
