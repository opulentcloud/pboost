class SurveyAnswersController < ApplicationController
	before_filter :require_user
	filter_access_to :all
  
  def new
		@survey_answer = SurveyAnswer.new
  
		respond_to do |format|
			format.html { redirect_to @survey_answer }
			format.js
		end
	end
end

