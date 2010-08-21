class SurveyResultsController < ApplicationController
	before_filter :require_user
	before_filter :get_survey, :only => [:show, :destroy]
	filter_access_to :all

  def index
    @surveys = current_political_campaign.surveys.all(:order => 'contact_lists.created_at DESC')
  end
  
  def show
		@results = @survey.results.summary  
  end
  
  def destroy
  	if !@survey.is_deleteable?
  		flash[:notice] = 'You can not delete this Survey while it is being populated.'
  		redirect_to @survey
  		return
  	end
    @survey.destroy
    flash[:notice] = "Successfully deleted Survey."
    redirect_to survey_results_url
  end
  
private

	#get the survey for the current user
	def get_survey
		begin
    @survey = current_political_campaign.surveys.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    	flash[:error] = "The requested Survey was not found."
    	redirect_back_or_default customer_control_panel_url
    end
	end

end

