class SurveyQuestionsController < ApplicationController
	before_filter :require_user
	filter_access_to :all
  ssl_required :new
  
  def new
		@survey_question = SurveyQuestion.new
		@sequence = params[:seq].to_i
  
		respond_to do |format|
			format.html { redirect_to @survey_question }
			format.js
		end
	end
end

